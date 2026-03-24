<#
.SYNOPSIS
    Install, upgrade, or uninstall Psyllama on Windows.

.DESCRIPTION
    Downloads and installs Psyllama.

    Quick install:

        irm https://psyllama.com/install.ps1 | iex

    Specific version:

        $env:PSYLLAMA_VERSION="0.5.7"; irm https://psyllama.com/install.ps1 | iex

    Custom install directory:

        $env:PSYLLAMA_INSTALL_DIR="D:\Psyllama"; irm https://psyllama.com/install.ps1 | iex

    Uninstall:

        $env:PSYLLAMA_UNINSTALL=1; irm https://psyllama.com/install.ps1 | iex

    Environment variables:

        PSYLLAMA_VERSION       Target version (default: latest stable)
        PSYLLAMA_INSTALL_DIR   Custom install directory
        PSYLLAMA_UNINSTALL     Set to 1 to uninstall Psyllama
        PSYLLAMA_DEBUG         Enable verbose output

.EXAMPLE
    irm https://psyllama.com/install.ps1 | iex

.EXAMPLE
    $env:PSYLLAMA_VERSION = "0.5.7"; irm https://psyllama.com/install.ps1 | iex

.LINK
    https://psyllama.com
#>

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# --------------------------------------------------------------------------
# Configuration from environment variables
# --------------------------------------------------------------------------

$Version      = if ($env:PSYLLAMA_VERSION) { $env:PSYLLAMA_VERSION } else { "" }
$InstallDir   = if ($env:PSYLLAMA_INSTALL_DIR) { $env:PSYLLAMA_INSTALL_DIR } else { "" }
$Uninstall    = $env:PSYLLAMA_UNINSTALL -eq "1"
$DebugInstall = [bool]$env:PSYLLAMA_DEBUG
$SkipSignature = $env:PSYLLAMA_SKIP_SIGNATURE_CHECK -eq "1"

# --------------------------------------------------------------------------
# Constants
# --------------------------------------------------------------------------

# PSYLLAMA_DOWNLOAD_URL for developer testing only
$GitHubRepo = if ($env:PSYLLAMA_GITHUB_REPO) { $env:PSYLLAMA_GITHUB_REPO } else { "LordPsyan/psyllama" }
$DownloadBaseURL = if ($env:PSYLLAMA_DOWNLOAD_URL) { $env:PSYLLAMA_DOWNLOAD_URL.TrimEnd('/') } else { "https://github.com/$GitHubRepo/releases" }
$InnoSetupUninstallGuid = "{A6D6E4A0-0C5E-4F1C-9E2F-2C3B8B7D2A4A}_is1"

# --------------------------------------------------------------------------
# Helpers
# --------------------------------------------------------------------------

function Write-Status {
    param([string]$Message)
    if ($DebugInstall) { Write-Host $Message }
}

function Write-Step {
    param([string]$Message)
    if ($DebugInstall) { Write-Host ">>> $Message" -ForegroundColor Cyan }
}

function Test-Signature {
    param([string]$FilePath)

    $sig = Get-AuthenticodeSignature -FilePath $FilePath
    if ($sig.Status -ne "Valid") {
        Write-Status "  Signature status: $($sig.Status)"
        return $false
    }

    # Verify it's signed by Psyllama Inc. (check exact organization name)
    # Anchor with comma/boundary to prevent "O=Not Psyllama Inc." from matching
    $subject = $sig.SignerCertificate.Subject
    if ($subject -notmatch "(^|, )O=Psyllama Inc\.(,|$)") {
        Write-Status "  Unexpected signer: $subject"
        return $false
    }

    Write-Status "  Signature valid: $subject"
    return $true
}

function Find-InnoSetupInstall {
    # Check both HKCU (per-user) and HKLM (per-machine) locations
    $possibleKeys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\$InnoSetupUninstallGuid",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\$InnoSetupUninstallGuid",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$InnoSetupUninstallGuid"
    )

    foreach ($key in $possibleKeys) {
        if (Test-Path $key) {
            Write-Status "  Found install at: $key"
            return $key
        }
    }
    return $null
}

function Update-SessionPath {
    # Update PATH in current session so 'psyllama' works immediately
    if ($InstallDir) {
        $psyllamaDir = $InstallDir
    } else {
        $psyllamaDir = Join-Path $env:LOCALAPPDATA "Programs\Psyllama"
    }

    # Add to PATH if not already present
    if (Test-Path $psyllamaDir) {
        $currentPath = $env:PATH -split ';'
        if ($psyllamaDir -notin $currentPath) {
            $env:PATH = "$psyllamaDir;$env:PATH"
            Write-Status "  Added $psyllamaDir to session PATH"
        }
    }
}

function Invoke-Download {
    param(
        [string]$Url,
        [string]$OutFile
    )

    Write-Status "  Downloading: $Url"
    try {
        $request = [System.Net.HttpWebRequest]::Create($Url)
        $request.AllowAutoRedirect = $true
        $response = $request.GetResponse()
        $totalBytes = $response.ContentLength
        $stream = $response.GetResponseStream()
        $fileStream = [System.IO.FileStream]::new($OutFile, [System.IO.FileMode]::Create)
        $buffer = [byte[]]::new(65536)
        $totalRead = 0
        $lastUpdate = [DateTime]::MinValue
        $barWidth = 40

        try {
            while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                $fileStream.Write($buffer, 0, $read)
                $totalRead += $read

                $now = [DateTime]::UtcNow
                if (($now - $lastUpdate).TotalMilliseconds -ge 250) {
                    if ($totalBytes -gt 0) {
                        $pct = [math]::Min(100.0, ($totalRead / $totalBytes) * 100)
                        $filled = [math]::Floor($barWidth * $pct / 100)
                        $empty = $barWidth - $filled
                        $bar = ('#' * $filled) + (' ' * $empty)
                        $pctFmt = $pct.ToString("0.0")
                        Write-Host -NoNewline "`r$bar ${pctFmt}%"
                    } else {
                        $sizeMB = [math]::Round($totalRead / 1MB, 1)
                        Write-Host -NoNewline "`r${sizeMB} MB downloaded..."
                    }
                    $lastUpdate = $now
                }
            }

            # Final progress update
            if ($totalBytes -gt 0) {
                $bar = '#' * $barWidth
                Write-Host "`r$bar 100.0%"
            } else {
                $sizeMB = [math]::Round($totalRead / 1MB, 1)
                Write-Host "`r${sizeMB} MB downloaded.          "
            }
        } finally {
            $fileStream.Close()
            $stream.Close()
            $response.Close()
        }
    } catch {
        if ($_.Exception -is [System.Net.WebException]) {
            $webEx = [System.Net.WebException]$_.Exception
            if ($webEx.Response -and ([System.Net.HttpWebResponse]$webEx.Response).StatusCode -eq [System.Net.HttpStatusCode]::NotFound) {
                throw "Download failed: not found at $Url"
            }
        }
        if ($_.Exception.InnerException -is [System.Net.WebException]) {
            $webEx = [System.Net.WebException]$_.Exception.InnerException
            if ($webEx.Response -and ([System.Net.HttpWebResponse]$webEx.Response).StatusCode -eq [System.Net.HttpStatusCode]::NotFound) {
                throw "Download failed: not found at $Url"
            }
        }
        throw "Download failed for ${Url}: $($_.Exception.Message)"
    }
}

# --------------------------------------------------------------------------
# Uninstall
# --------------------------------------------------------------------------

function Invoke-Uninstall {
    Write-Step "Uninstalling Psyllama"

    $regKey = Find-InnoSetupInstall
    if (-not $regKey) {
        Write-Host ">>> Psyllama is not installed."
        return
    }

    $uninstallString = (Get-ItemProperty -Path $regKey).UninstallString
    if (-not $uninstallString) {
        Write-Warning "No uninstall string found in registry"
        return
    }

    # Strip quotes if present
    $uninstallExe = $uninstallString -replace '"', ''
    Write-Status "  Uninstaller: $uninstallExe"

    if (-not (Test-Path $uninstallExe)) {
        Write-Warning "Uninstaller not found at: $uninstallExe"
        return
    }

    Write-Host ">>> Launching uninstaller..."
    # Run with GUI so user can choose whether to keep models
    Start-Process -FilePath $uninstallExe -Wait

    # Verify removal
    if (Find-InnoSetupInstall) {
        Write-Warning "Uninstall may not have completed"
    } else {
        Write-Host ">>> Psyllama has been uninstalled."
    }
}

# --------------------------------------------------------------------------
# Install
# --------------------------------------------------------------------------

function Invoke-Install {
    # Determine installer URL
    if ($Version) {
        $tag = $Version
        if ($tag -notmatch '^v') {
            $tag = "v$tag"
        }
        $installerUrl = "$DownloadBaseURL/download/$tag/PsyllamaSetup.exe"
    } else {
        $installerUrl = "$DownloadBaseURL/latest/download/PsyllamaSetup.exe"
    }

    # Download installer
    Write-Step "Downloading Psyllama"
    if (-not $DebugInstall) {
        Write-Host ">>> Downloading Psyllama for Windows..."
    }

    $tempInstaller = Join-Path $env:TEMP "PsyllamaSetup.exe"
    Invoke-Download -Url $installerUrl -OutFile $tempInstaller

    # Verify signature
    Write-Step "Verifying signature"
    if (-not $SkipSignature) {
        if (-not (Test-Signature -FilePath $tempInstaller)) {
            Remove-Item $tempInstaller -Force -ErrorAction SilentlyContinue
            throw "Installer signature verification failed"
        }
    }

    # Build installer arguments
    $installerArgs = "/VERYSILENT /NORESTART /SUPPRESSMSGBOXES"
    if ($InstallDir) {
        $installerArgs += " /DIR=`"$InstallDir`""
    }
    Write-Status "  Installer args: $installerArgs"

    # Run installer
    Write-Step "Installing Psyllama"
    if (-not $DebugInstall) {
        Write-Host ">>> Installing Psyllama..."
    }

    # Create upgrade marker so the app starts hidden
    # The app checks for this file on startup and removes it after
    $markerDir = Join-Path $env:LOCALAPPDATA "Psyllama"
    $markerFile = Join-Path $markerDir "upgraded"
    if (-not (Test-Path $markerDir)) {
        New-Item -ItemType Directory -Path $markerDir -Force | Out-Null
    }
    New-Item -ItemType File -Path $markerFile -Force | Out-Null
    Write-Status "  Created upgrade marker: $markerFile"

    # Start installer and wait for just the installer process (not children)
    # Using -Wait would wait for Psyllama to exit too, which we don't want
    $proc = Start-Process -FilePath $tempInstaller `
        -ArgumentList $installerArgs `
        -PassThru
    $proc.WaitForExit()

    if ($proc.ExitCode -ne 0) {
        Remove-Item $tempInstaller -Force -ErrorAction SilentlyContinue
        throw "Installation failed with exit code $($proc.ExitCode)"
    }

    # Cleanup
    Remove-Item $tempInstaller -Force -ErrorAction SilentlyContinue

    # Update PATH in current session so 'psyllama' works immediately
    Write-Step "Updating session PATH"
    Update-SessionPath

    Write-Host ">>> Install complete. Run 'psyllama' from the command line."
}

# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------

if ($Uninstall) {
    Invoke-Uninstall
} else {
    Invoke-Install
}
