#!/bin/sh

# Note: 
#  While testing, if you double-click on the Psyllama.app 
#  some state is left on MacOS and subsequent attempts
#  to build again will fail with:
#
#    hdiutil: create failed - Operation not permitted
#
#  To work around, specify another volume name with:
#
#    VOL_NAME="$(date)" ./scripts/build_darwin.sh
#
VOL_NAME=${VOL_NAME:-"Psyllama"}
export VERSION=${VERSION:-$(git describe --tags --first-parent --abbrev=7 --long --dirty --always | sed -e "s/^v//g")}
export GOFLAGS="'-ldflags=-w -s \"-X=github.com/psyllama/psyllama/version.Version=${VERSION#v}\" \"-X=github.com/psyllama/psyllama/server.mode=release\"'"
export CGO_CFLAGS="-O3 -mmacosx-version-min=14.0"
export CGO_CXXFLAGS="-O3 -mmacosx-version-min=14.0"
export CGO_LDFLAGS="-mmacosx-version-min=14.0"

set -e

status() { echo >&2 ">>> $@"; }
usage() {
    echo "usage: $(basename $0) [build app [sign]]"
    exit 1
}

mkdir -p dist


ARCHS="arm64 amd64"
while getopts "a:h" OPTION; do
    case $OPTION in
        a) ARCHS=$OPTARG ;;
        h) usage ;;
    esac
done

shift $(( $OPTIND - 1 ))

_build_darwin() {
    for ARCH in $ARCHS; do
        status "Building darwin $ARCH"
        INSTALL_PREFIX=dist/darwin-$ARCH/        

        if [ "$ARCH" = "amd64" ]; then
            status "Building darwin $ARCH dynamic backends"
            BUILD_DIR=build/darwin-$ARCH
            cmake -B $BUILD_DIR \
                -DCMAKE_OSX_ARCHITECTURES=x86_64 \
                -DCMAKE_OSX_DEPLOYMENT_TARGET=14.0 \
                -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
                -DMLX_ENGINE=ON \
                -DMLX_ENABLE_X64_MAC=ON \
                -DPSYLLAMA_RUNNER_DIR=./
            cmake --build $BUILD_DIR --target ggml-cpu -j
            cmake --build $BUILD_DIR --target mlx mlxc -j
            cmake --install $BUILD_DIR --component CPU
            cmake --install $BUILD_DIR --component MLX
            # Override CGO flags to point to the amd64 build directory
            MLX_CGO_CFLAGS="-O3 -mmacosx-version-min=14.0"
            MLX_CGO_LDFLAGS="-ldl -lc++ -framework Accelerate -mmacosx-version-min=14.0"
        else
            BUILD_DIR=build
            cmake --preset MLX \
                -DPSYLLAMA_RUNNER_DIR=./ \
                -DCMAKE_OSX_DEPLOYMENT_TARGET=14.0 \
                -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX
            cmake --build --preset MLX --parallel
            cmake --install $BUILD_DIR --component MLX
            # Use default CGO flags from mlx.go for arm64
            MLX_CGO_CFLAGS="-O3 -mmacosx-version-min=14.0"
            MLX_CGO_LDFLAGS="-lc++ -framework Metal -framework Foundation -framework Accelerate -mmacosx-version-min=14.0"
        fi
        GOOS=darwin GOARCH=$ARCH CGO_ENABLED=1 CGO_CFLAGS="$MLX_CGO_CFLAGS" CGO_LDFLAGS="$MLX_CGO_LDFLAGS" go build -o $INSTALL_PREFIX .
        # Copy MLX libraries to same directory as executable for dlopen
        cp $INSTALL_PREFIX/lib/psyllama/libmlxc.dylib $INSTALL_PREFIX/
        cp $INSTALL_PREFIX/lib/psyllama/libmlx.dylib $INSTALL_PREFIX/
    done
}

_sign_darwin() {
    status "Creating universal binary..."
    mkdir -p dist/darwin
    lipo -create -output dist/darwin/psyllama dist/darwin-*/psyllama
    chmod +x dist/darwin/psyllama

    if [ -n "$APPLE_IDENTITY" ]; then
        for F in dist/darwin/psyllama dist/darwin-*/lib/psyllama/*; do
            codesign -f --timestamp -s "$APPLE_IDENTITY" --identifier ai.psyllama.psyllama --options=runtime $F
        done

        # create a temporary zip for notarization
        TEMP=$(mktemp -u).zip
        ditto -c -k --keepParent dist/darwin/psyllama "$TEMP"
        xcrun notarytool submit "$TEMP" --wait --timeout 20m --apple-id $APPLE_ID --password $APPLE_PASSWORD --team-id $APPLE_TEAM_ID
        rm -f "$TEMP"
    fi

    status "Creating universal tarball..."
    tar -cf dist/psyllama-darwin.tar --strip-components 2 dist/darwin/psyllama
    tar -rf dist/psyllama-darwin.tar --strip-components 4 dist/darwin-amd64/lib/
    gzip -9vc <dist/psyllama-darwin.tar >dist/psyllama-darwin.tgz
}

_build_macapp() {
    if ! command -v npm &> /dev/null; then
        echo "npm is not installed. Please install Node.js and npm first:"
        echo "   Visit: https://nodejs.org/"
        exit 1
    fi

    if ! command -v tsc &> /dev/null; then
        echo "Installing TypeScript compiler..."
        npm install -g typescript
    fi

    echo "Installing required Go tools..."

    cd app/ui/app
    npm install
    npm run build
    cd ../../..

    # Build the Psyllama.app bundle
    rm -rf dist/Psyllama.app
    cp -a ./app/darwin/Psyllama.app dist/Psyllama.app

    # update the modified date of the app bundle to now
    touch dist/Psyllama.app

    go clean -cache
    GOARCH=amd64 CGO_ENABLED=1 GOOS=darwin go build -o dist/darwin-app-amd64 -ldflags="-s -w -X=github.com/psyllama/psyllama/app/version.Version=${VERSION}" ./app/cmd/app
    GOARCH=arm64 CGO_ENABLED=1 GOOS=darwin go build -o dist/darwin-app-arm64 -ldflags="-s -w -X=github.com/psyllama/psyllama/app/version.Version=${VERSION}" ./app/cmd/app
    mkdir -p dist/Psyllama.app/Contents/MacOS
    lipo -create -output dist/Psyllama.app/Contents/MacOS/Psyllama dist/darwin-app-amd64 dist/darwin-app-arm64
    rm -f dist/darwin-app-amd64 dist/darwin-app-arm64

    # Create a mock Squirrel.framework bundle
    mkdir -p dist/Psyllama.app/Contents/Frameworks/Squirrel.framework/Versions/A/Resources/
    cp -a dist/Psyllama.app/Contents/MacOS/Psyllama dist/Psyllama.app/Contents/Frameworks/Squirrel.framework/Versions/A/Squirrel
    ln -s ../Squirrel dist/Psyllama.app/Contents/Frameworks/Squirrel.framework/Versions/A/Resources/ShipIt
    cp -a ./app/cmd/squirrel/Info.plist dist/Psyllama.app/Contents/Frameworks/Squirrel.framework/Versions/A/Resources/Info.plist
    ln -s A dist/Psyllama.app/Contents/Frameworks/Squirrel.framework/Versions/Current
    ln -s Versions/Current/Resources dist/Psyllama.app/Contents/Frameworks/Squirrel.framework/Resources
    ln -s Versions/Current/Squirrel dist/Psyllama.app/Contents/Frameworks/Squirrel.framework/Squirrel

    # Update the version in the Info.plist
    plutil -replace CFBundleShortVersionString -string "$VERSION" dist/Psyllama.app/Contents/Info.plist
    plutil -replace CFBundleVersion -string "$VERSION" dist/Psyllama.app/Contents/Info.plist

    # Setup the psyllama binaries
    mkdir -p dist/Psyllama.app/Contents/Resources
    if [ -d dist/darwin-amd64 ]; then
        lipo -create -output dist/Psyllama.app/Contents/Resources/psyllama dist/darwin-amd64/psyllama dist/darwin-arm64/psyllama
        for F in dist/darwin-amd64/lib/psyllama/*mlx*.dylib ; do
            lipo -create -output dist/darwin/$(basename $F) $F dist/darwin-arm64/lib/psyllama/$(basename $F)
        done
        cp dist/darwin-*/lib/psyllama/*.so dist/darwin-*/lib/psyllama/*.dylib dist/Psyllama.app/Contents/Resources/
        cp dist/darwin/*.dylib dist/Psyllama.app/Contents/Resources/
        # Copy MLX metallib (architecture-independent, just use arm64 version)
        cp dist/darwin-arm64/lib/psyllama/*.metallib dist/Psyllama.app/Contents/Resources/ 2>/dev/null || true
    else
        cp -a dist/darwin/psyllama dist/Psyllama.app/Contents/Resources/psyllama
        cp dist/darwin/*.so dist/darwin/*.dylib dist/Psyllama.app/Contents/Resources/
    fi
    chmod a+x dist/Psyllama.app/Contents/Resources/psyllama

    # Sign
    if [ -n "$APPLE_IDENTITY" ]; then
        codesign -f --timestamp -s "$APPLE_IDENTITY" --identifier ai.psyllama.psyllama --options=runtime dist/Psyllama.app/Contents/Resources/psyllama
        for lib in dist/Psyllama.app/Contents/Resources/*.so dist/Psyllama.app/Contents/Resources/*.dylib dist/Psyllama.app/Contents/Resources/*.metallib ; do
            codesign -f --timestamp -s "$APPLE_IDENTITY" --identifier ai.psyllama.psyllama --options=runtime ${lib}
        done
        codesign -f --timestamp -s "$APPLE_IDENTITY" --identifier com.electron.psyllama --deep --options=runtime dist/Psyllama.app
    fi

    rm -f dist/Psyllama-darwin.zip
    ditto -c -k --norsrc --keepParent dist/Psyllama.app dist/Psyllama-darwin.zip
    (cd dist/Psyllama.app/Contents/Resources/; tar -cf - psyllama *.so *.dylib *.metallib 2>/dev/null) | gzip -9vc > dist/psyllama-darwin.tgz

    # Notarize and Staple
    if [ -n "$APPLE_IDENTITY" ]; then
        $(xcrun -f notarytool) submit dist/Psyllama-darwin.zip --wait --timeout 20m --apple-id "$APPLE_ID" --password "$APPLE_PASSWORD" --team-id "$APPLE_TEAM_ID"
        rm -f dist/Psyllama-darwin.zip
        $(xcrun -f stapler) staple dist/Psyllama.app
        ditto -c -k --norsrc --keepParent dist/Psyllama.app dist/Psyllama-darwin.zip

        rm -f dist/Psyllama.dmg

        (cd dist && ../scripts/create-dmg.sh \
            --volname "${VOL_NAME}" \
            --volicon ../app/darwin/Psyllama.app/Contents/Resources/icon.icns \
            --background ../app/assets/background.png \
            --window-pos 200 120 \
            --window-size 800 400 \
            --icon-size 128 \
            --icon "Psyllama.app" 200 190 \
            --hide-extension "Psyllama.app" \
            --app-drop-link 600 190 \
            --text-size 12 \
            "Psyllama.dmg" \
            "Psyllama.app" \
        ; )
        rm -f dist/rw*.dmg

        codesign -f --timestamp -s "$APPLE_IDENTITY" --identifier ai.psyllama.psyllama --options=runtime dist/Psyllama.dmg
        $(xcrun -f notarytool) submit dist/Psyllama.dmg --wait --timeout 20m --apple-id "$APPLE_ID" --password "$APPLE_PASSWORD" --team-id "$APPLE_TEAM_ID"
        $(xcrun -f stapler) staple dist/Psyllama.dmg
    else
        echo "WARNING: Code signing disabled, this bundle will not work for upgrade testing"
    fi
}

if [ "$#" -eq 0 ]; then
    _build_darwin
    _sign_darwin
    _build_macapp
    exit 0
fi

for CMD in "$@"; do
    case $CMD in
        build) _build_darwin ;;
        sign) _sign_darwin ;;
        app) _build_macapp ;;
        *) usage ;;
    esac
done
