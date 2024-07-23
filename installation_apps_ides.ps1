param (
    [string]$app,
    [string]$ide
)

# Determine the path to the Desktop
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")

# Create the log.txt file on the Desktop
$logFile = [System.IO.Path]::Combine($desktopPath, "log.txt")
New-Item -Path $logFile -ItemType "File"

# Initialize installation status
$installationSuccessful = $false
$ideinstallationsucess = $false

# Function to log messages to the log file
function Log-Message ($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}

function Install-App ($appName) {
    switch ($appName.ToLower()) {
        "python" {
            Log-Message "Installing Python..."
            winget install --id Python.Python.3.12
            if (Test-Path "C:\Users\$env:UserName\AppData\Local\Programs\Python\Python312\python.exe") {
                $global:installationSuccessful = $true
            }
        }
        "docker" {
            Log-Message "Installing Docker..."
            winget install --id Docker.DockerDesktop
            if (Test-Path "C:\Program Files\Docker\Docker\Docker Desktop.exe") {
                $global:installationSuccessful = $true
            }
        }
        "git" {
            Log-Message "Installing Git..."
            winget install --id Git.Git
            if (Test-Path "C:\Program Files\Git\cmd\git.exe") {
                $global:installationSuccessful = $true
            }
        }
        "notepad++" {
            Log-Message "Installing Notepad++..."
            winget install --id Notepad++.Notepad++
            if (Test-Path "C:\Program Files\Notepad++\notepad++.exe") {
                $global:installationSuccessful = $true
            }
        }
        "winscp" {
            Log-Message "Installing WinSCP..."
            winget install --id WinSCP.WinSCP
            if (Test-Path "C:\Users\$env:UserName\AppData\Local\Programs\WinSCP\WinSCP.exe") {
                $global:installationSuccessful = $true
            }
        }
        "google-sdk" {
            Log-Message "Installing Google Cloud SDK..."
            $installerPath = "$env:Temp\GoogleCloudSDKInstaller.exe"
            (New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", $installerPath)
            & $installerPath /S
            if (Test-Path "C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.exe") {
                $global:installationSuccessful = $true
            }
        }
        default {
            Log-Message "Application not recognized: $appName"
        }
    }
}

function Update-Path ($pathToAdd) {
    $oldPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    
    if ($oldPath -notlike "*$pathToAdd*") {
        $newPath = "$oldPath;$pathToAdd"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
        Log-Message "Path updated: $pathToAdd"
    } else {
        Log-Message "Path already contains: $pathToAdd"
    }
}

# Install and update path for the app
Install-App $app

if ($installationSuccessful) {
    switch ($app.ToLower()) {
        "python" {
            Update-Path "C:\Users\$env:UserName\AppData\Local\Programs\Python\Python312"
        }
        "docker" {
            Update-Path "C:\Program Files\Docker\Docker\resources\bin"
        }
        "git" {
            Update-Path "C:\Program Files\Git\cmd"
        }
        "notepad++" {
            Update-Path "C:\Program Files\Notepad++"
        }
        "winscp" {
            Update-Path "C:\Users\$env:UserName\AppData\Local\Programs\WinSCP\WinSCP.exe"
        }
        "google-sdk" {
            Update-Path "C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin"
        }
    }
} else {
    Log-Message "$app installation failed. Skipping path update."
}

# Install and update path for the selected IDE
switch ($ide.ToLower()) {
    "intellij" {
        Log-Message "Installing IntelliJ IDEA..."
        winget install --id JetBrains.IntelliJIDEA.Ultimate
        if (Test-Path "C:\Program Files\JetBrains\IntelliJ IDEA 2023.1\bin\idea64.exe") {
            Update-Path "C:\Program Files\JetBrains\IntelliJ IDEA 2023.1\bin"
			$global:ideinstallationsucess = $true
        } else {
            Log-Message "Failed to install IntelliJ IDEA."
        }
    }
    "pycharm" {
        Log-Message "Installing PyCharm..."
        winget install --id JetBrains.PyCharm.Professional
        if (Test-Path "C:\Program Files\JetBrains\PyCharm 2023.1\bin\pycharm64.exe") {
            Update-Path "C:\Program Files\JetBrains\PyCharm 2023.1\bin"
			$global:ideinstallationsucess = $true
        } else {
            Log-Message "Failed to install PyCharm."
        }
    }
    "vscode" {
        Log-Message "Installing Visual Studio Code..."
        winget install --id Microsoft.VisualStudioCode
        if (Test-Path "C:\Users\$env:UserName\AppData\Local\Programs\Microsoft VS Code\bin\code.exe") {
            Update-Path "C:\Users\$env:UserName\AppData\Local\Programs\Microsoft VS Code\bin"
			$global:ideinstallationsucess = $true
        } else {
            Log-Message "Failed to install Visual Studio Code."
        }
    }
    default {
        Log-Message "IDE not recognized. Please enter one of the following: IntelliJ, PyCharm, VSCode."
    }
}

# Final log messages
Log-Message "All selected applications and Google Cloud SDKs installed successfully."
Log-Message "Restart your computer for the changes to take effect."

Write-Output $installationSuccessful