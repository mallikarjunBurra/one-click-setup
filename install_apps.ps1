#.\install_apps.ps1 -apps "Python", "Docker", "Git" -ide "Pycharm"


param (
    [string[]]$apps,
    [string]$ide
)

function Install-App ($appName) {
    switch ($appName.ToLower()) {
        "python" {
            Write-Output "Installing Python..."
            winget install --id Python.Python.3
        }
        "docker" {
            Write-Output "Installing Docker..."
            winget install --id Docker.DockerDesktop
        }
        "git" {
            Write-Output "Installing Git..."
            winget install --id Git.Git
        }
        "notepad++" {
            Write-Output "Installing Notepad++..."
            winget install --id Notepad++.Notepad++
        }
        "winscp" {
            Write-Output "Installing WinSCP..."
            winget install --id WinSCP.WinSCP
        }
        "google-sdk" {
            Write-Output "Installing Google Cloud SDK..."
            $installerPath = "$env:Temp\GoogleCloudSDKInstaller.exe"
            (New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", $installerPath)
            & $installerPath /S
		}
        default {
            Write-Output "Application not recognized: $appName"
        }
    }
}

function Update-Path ($pathToAdd) {
    $oldPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    
    if ($oldPath -notlike "*$pathToAdd*") {
        $newPath = "$oldPath;$pathToAdd"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "Path updated: $pathToAdd"
    } else {
        Write-Output "Path already contains: $pathToAdd"
    }
}

# Install and update path for all apps
foreach ($app in $apps) {
    Install-App $app

    switch ($app.ToLower()) {
        "java" {
            Update-Path "C:\Program Files\Microsoft\jdk-17\bin"
        }
        "python" {
            Update-Path "C:\Users\$env:UserName\AppData\Local\Programs\Python\Python39"
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
            Update-Path "C:\Program Files (x86)\WinSCP"
        }
    }
}

# Install and update path for the selected IDE
switch ($ide.ToLower()) {
    "intellij" {
        Write-Output "Installing IntelliJ IDEA..."
        winget install --id JetBrains.IntelliJIDEA.Ultimate
        Update-Path "C:\Program Files\JetBrains\IntelliJ IDEA 2023.1\bin"
    }
    "pycharm" {
        Write-Output "Installing PyCharm..."
        winget install --id JetBrains.PyCharm.Professional
        Update-Path "C:\Program Files\JetBrains\PyCharm 2023.1\bin"
    }
    "vscode" {
        Write-Output "Installing Visual Studio Code..."
        winget install --id Microsoft.VisualStudioCode
        Update-Path "C:\Users\$env:UserName\AppData\Local\Programs\Microsoft VS Code\bin"
    }
    default {
        Write-Output "IDE not recognized. Please enter one of the following: IntelliJ, PyCharm, VSCode."
    }
}

# Install and update path for Google Cloud SDK by default
Install-App "google-sdk"
Update-Path "C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin"

#Final output messages
Write-Output "All selected applications and Google Cloud SDKs installed successfully."
Write-Output "Restart your computer for the changes to take effect."
