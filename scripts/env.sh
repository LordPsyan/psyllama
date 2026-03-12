# Common environment setup across build*.sh scripts

export VERSION=${VERSION:-$(git describe --tags --first-parent --abbrev=7 --long --dirty --always | sed -e "s/^v//g")}
export GOFLAGS="'-ldflags=-w -s \"-X=github.com/psyllama/psyllama/version.Version=$VERSION\" \"-X=github.com/psyllama/psyllama/server.mode=release\"'"
# TODO - consider `docker buildx ls --format=json` to autodiscover platform capability
PLATFORM=${PLATFORM:-"linux/arm64,linux/amd64"}
DOCKER_ORG=${DOCKER_ORG:-"psyllama"}
FINAL_IMAGE_REPO=${FINAL_IMAGE_REPO:-"${DOCKER_ORG}/psyllama"}
PSYLLAMA_COMMON_BUILD_ARGS="--build-arg=VERSION \
    --build-arg=GOFLAGS \
    --build-arg=PSYLLAMA_CUSTOM_CPU_DEFS \
    --build-arg=PSYLLAMA_SKIP_CUDA_GENERATE \
    --build-arg=PSYLLAMA_SKIP_CUDA_12_GENERATE \
    --build-arg=CUDA_V12_ARCHITECTURES \
    --build-arg=PSYLLAMA_SKIP_ROCM_GENERATE \
    --build-arg=PSYLLAMA_FAST_BUILD \
    --build-arg=CUSTOM_CPU_FLAGS \
    --build-arg=GPU_RUNNER_CPU_FLAGS \
    --build-arg=AMDGPU_TARGETS"

# Forward local MLX source overrides as Docker build contexts
if [ -n "${PSYLLAMA_MLX_SOURCE:-}" ]; then
    PSYLLAMA_COMMON_BUILD_ARGS="$PSYLLAMA_COMMON_BUILD_ARGS --build-context local-mlx=$(cd "$PSYLLAMA_MLX_SOURCE" && pwd)"
fi
if [ -n "${PSYLLAMA_MLX_C_SOURCE:-}" ]; then
    PSYLLAMA_COMMON_BUILD_ARGS="$PSYLLAMA_COMMON_BUILD_ARGS --build-context local-mlx-c=$(cd "$PSYLLAMA_MLX_C_SOURCE" && pwd)"
fi

echo "Building Psyllama"
echo "VERSION=$VERSION"
echo "PLATFORM=$PLATFORM"