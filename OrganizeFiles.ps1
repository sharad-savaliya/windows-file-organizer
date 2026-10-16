
# ============================================================
# Windows File Organizer
# Organizes files by extension - Move Only
# No intentional file deletion or overwriting
# ============================================================

$ErrorActionPreference = 'Stop'

# Console title
$Host.UI.RawUI.WindowTitle = 'Windows File Organizer'

# ------------------------------------------------------------
# 1. File Categories and Extensions
# ------------------------------------------------------------

$map = @{
    Image = @(
        '.jpg', '.jpeg', '.png', '.gif', '.bmp',
        '.webp', '.svg', '.ico', '.tif', '.tiff',
        '.heic', '.psd', '.ai', '.raw'
    )

    Video = @(
        '.mp4', '.mkv', '.mov', '.avi', '.wmv',
        '.flv', '.webm', '.m4v', '.mpeg', '.mpg',
        '.3gp'
    )

    Document = @(
        '.pdf', '.doc', '.docx', '.txt', '.rtf',
        '.odt', '.xls', '.xlsx', '.csv', '.ods',
        '.ppt', '.pptx', '.odp', '.md', '.epub'
    )

    Coding = @(
        '.php', '.js', '.jsx', '.ts', '.tsx',
        '.html', '.htm', '.css', '.scss', '.sass',
        '.json', '.xml', '.sql', '.py', '.java',
        '.c', '.cpp', '.h', '.cs', '.go', '.rb',
        '.sh', '.bat', '.cmd', '.ps1', '.yml',
        '.yaml', '.toml', '.ini', '.vue', '.svelte',
        '.dart', '.kt', '.swift', '.rs', '.ipynb'
    )

    Compress = @(
        '.zip', '.rar', '.7z', '.tar', '.gz',
        '.bz2', '.xz', '.tgz', '.zst'
    )

    Software = @(
        '.exe', '.msi', '.msp', '.msix',
        '.appx', '.apk', '.deb', '.rpm', '.dmg'
    )

    Audio = @(
        '.mp3', '.wav', '.aac', '.flac',
        '.ogg', '.m4a', '.wma'
    )
}

# ------------------------------------------------------------
# 2. Select Folder
# ------------------------------------------------------------

try {
    Add-Type -AssemblyName System.Windows.Forms

    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = 'Select the folder whose files you want to organize'
    $dialog.ShowNewFolderButton = $false

    $result = $dialog.ShowDialog()

    if ($result -ne [System.Windows.Forms.DialogResult]::OK) {
        Write-Host ''
        Write-Host 'Operation cancelled. No files were moved.' -ForegroundColor Yellow
        exit 0
    }

    $root = $dialog.SelectedPath

    if (-not (Test-Path -LiteralPath $root -PathType Container)) {
        throw "Selected folder does not exist: $root"
    }
}
catch {
    Write-Host ''
    Write-Host "Unable to select folder: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# ------------------------------------------------------------
# 3. Display Information
# ------------------------------------------------------------

Write-Host ''
Write-Host '==================================================' -ForegroundColor Cyan
Write-Host '           WINDOWS FILE ORGANIZER' -ForegroundColor Cyan
Write-Host '           MOVE ONLY - NO DELETE' -ForegroundColor Cyan
Write-Host '==================================================' -ForegroundColor Cyan
Write-Host ''
Write-Host "Selected folder: $root" -ForegroundColor White
Write-Host 'Subfolders will not be scanned.' -ForegroundColor Yellow
Write-Host 'Duplicate destination filenames will be skipped.' -ForegroundColor Yellow
Write-Host ''

# ------------------------------------------------------------
# 4. Initialize Counters
# ------------------------------------------------------------

$movedCount = 0
$skippedCount = 0
$errorCount = 0

# ------------------------------------------------------------
# 5. Process Files
# ------------------------------------------------------------

try {
    # Only files directly inside the selected folder
    $files = @(Get-ChildItem -LiteralPath $root -File -ErrorAction Stop)

    foreach ($file in $files) {

        # Skip organizer scripts themselves
        if ($file.Name -in @(
            'OrganizeFiles.ps1',
            'OrganizeFiles.bat'
        )) {
            continue
        }

        $extension = $file.Extension.ToLowerInvariant()
        $category = $null

        # Find the matching category
        foreach ($name in $map.Keys) {
            if ($map[$name] -contains $extension) {
                $category = $name
                break
            }
        }

        # Ignore unsupported extensions
        if (-not $category) {
            continue
        }

        $destinationFolder = Join-Path -Path $root -ChildPath $category

        # Create folder only when a matching file exists
        if (-not (Test-Path -LiteralPath $destinationFolder -PathType Container)) {
            try {
                New-Item -ItemType Directory -Path $destinationFolder -ErrorAction Stop |
                    Out-Null
            }
            catch {
                Write-Host "ERROR creating folder: $category" -ForegroundColor Red
                $errorCount++
                continue
            }
        }

        $destination = Join-Path -Path $destinationFolder -ChildPath $file.Name

        # Never overwrite an existing destination file
        if (Test-Path -LiteralPath $destination) {
            Write-Host "SKIPPED [Duplicate]: $($file.Name)" -ForegroundColor Yellow
            $skippedCount++
            continue
        }

        # Move the file
        try {
            Move-Item `
                -LiteralPath $file.FullName `
                -Destination $destination `
                -ErrorAction Stop

            Write-Host "MOVED [$category]: $($file.Name)" -ForegroundColor Green
            $movedCount++
        }
        catch {
            Write-Host "ERROR moving $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }
}
catch {
    Write-Host "ERROR reading selected folder: $($_.Exception.Message)" -ForegroundColor Red
    $errorCount++
}

# ------------------------------------------------------------
# 6. Summary
# ------------------------------------------------------------

Write-Host ''
Write-Host '==================================================' -ForegroundColor Cyan
Write-Host '             ORGANIZATION SUMMARY' -ForegroundColor Cyan
Write-Host '==================================================' -ForegroundColor Cyan
Write-Host "Selected folder : $root"
Write-Host "Files moved     : $movedCount" -ForegroundColor Green
Write-Host "Files skipped   : $skippedCount" -ForegroundColor Yellow
Write-Host "Errors          : $errorCount" -ForegroundColor Red
Write-Host ''
Write-Host 'Organization process finished.' -ForegroundColor Cyan
Write-Host 'Review the destination folders and verify your files.'
Write-Host '==================================================' -ForegroundColor Cyan
