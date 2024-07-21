#.\install_apps.ps1 -apps "Python", "Java", "Git" -versions "3.9.1", "1.8", "" -ide "Pycharm"

param (
    [string[]]$apps,
    [string[]]$versions,
    [string]$ide
)

function Install-App ($appName, $version) {
    switch ($appName.ToLower()) {
        "java" {
            if ($version) {
                Write-Output "Installing Java $version..."
                winget install --id Microsoft.OpenJDK --version $version
            } else {
                Write-Output "Installing Java..."
                winget install --id Microsoft.OpenJDK.17
            }
        }
        "python" {
            if ($version) {
                Write-Output "Installing Python $version..."
                winget install --id Python.Python.3 --version $version
            } else {
                Write-Output "Installing Python..."
                winget install --id Python.Python.3
            }
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

for ($i = 0; $i -lt $apps.Length; $i++) {
    Install-App $apps[$i] $versions[$i]

    switch ($apps[$i].ToLower()) {
        "java" {
            $javaPath = "C:\Program Files\Microsoft\jdk-" + $versions[$i] + "\bin"
            Update-Path $javaPath
        }
        "python" {
            $pythonPath = "C:\Users\$env:UserName\AppData\Local\Programs\Python\Python" + $versions[$i].Replace(".", "")
            Update-Path $pythonPath
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

switch ($ide.ToLower()) {
    "intellij" {
        Write-Output "Installing IntelliJ IDEA..."
        winget install --id JetBrains.IntelliJIDEA.Ultimate
        $intellijPath = "C:\Program Files\JetBrains\IntelliJ IDEA 2023.1\bin"
        Update-Path $intellijPath
    }
    "pycharm" {
        Write-Output "Installing PyCharm..."
        winget install --id JetBrains.PyCharm.Professional
        $pycharmPath = "C:\Program Files\JetBrains\PyCharm 2023.1\bin"
        Update-Path $pycharmPath
    }
    "vscode" {
        Write-Output "Installing Visual Studio Code..."
        winget install --id Microsoft.VisualStudioCode
        $vscodePath = "C:\Users\$env:UserName\AppData\Local\Programs\Microsoft VS Code\bin"
        Update-Path $vscodePath
    }
    default {
        Write-Output "IDE not recognized. Please enter one of the following: IntelliJ, PyCharm, VSCode."
    }
}
