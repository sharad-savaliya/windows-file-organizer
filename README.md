# Windows File Organizer

A lightweight Windows utility that organizes files into folders based on their file extensions using PowerShell and a simple Batch launcher.

## Features

- **Automatic organization:** Sort files into category folders.
- **Move-only operation:** Moves files instead of copying them.
- **No intentional file deletion:** The script does not contain a file-deletion command.
- **Duplicate protection:** Skips files when a destination file with the same name already exists.
- **Automatic folder creation:** Creates a category folder only when a matching file needs to be moved.
- **Folder selection:** Choose the directory you want to organize.
- **Simple interface:** Launch the tool by double-clicking a `.bat` file.
- **No third-party dependencies:** Uses built-in Windows PowerShell functionality.

## Supported Categories

| Folder | Supported file types |
|---|---|
| `Image` | JPG, JPEG, PNG, GIF, BMP, WEBP, SVG, ICO, TIFF, HEIC, PSD, AI, RAW |
| `Video` | MP4, MKV, MOV, AVI, WMV, FLV, WEBM, M4V, MPEG, MPG, 3GP |
| `Document` | PDF, DOC, DOCX, TXT, RTF, ODT, XLS, XLSX, CSV, ODS, PPT, PPTX, ODP, MD, EPUB |
| `Coding` | PHP, JS, JSX, TS, TSX, HTML, CSS, JSON, XML, SQL, Python, Java, C, C++, C#, Go, Ruby, Shell, PowerShell and other configured source/configuration formats |
| `Compress` | ZIP, RAR, 7Z, TAR, GZ, BZ2, XZ, TGZ, ZST |
| `Software` | EXE, MSI, MSP, MSIX, APPX, APK, DEB, RPM, DMG |
| `Audio` | MP3, WAV, AAC, FLAC, OGG, M4A, WMA |

Only extensions configured in the script are organized. Other file types remain untouched.

## Requirements

- Windows 10 or Windows 11
- Windows PowerShell
- Permission to access and move files in the selected directory

## Installation

### Option 1: Download from GitHub

1. Open this repository on GitHub.
2. Click **Code → Download ZIP**.
3. Extract the downloaded ZIP file.
4. Keep `OrganizeFiles.ps1` and `OrganizeFiles.bat` in the same directory.

### Option 2: Clone the repository

If Git is installed, run:

```bash
git clone https://github.com/sharad-savaliya/windows-file-organizer.git
cd windows-file-organizer
```

## How to Use

1. Open the extracted project folder.
2. Double-click `OrganizeFiles.bat`.
3. Select the folder you want to organize.
4. Confirm the selected folder and review the console output.
5. Check the resulting category folders.

The tool processes files directly inside the selected folder. It does not recursively scan subdirectories.

## Safety and Limitations

- Files are moved, not copied.
- The script does not intentionally delete files.
- Files with duplicate destination names are skipped rather than overwritten.
- Unsupported file extensions are ignored.
- Existing category folders are reused.
- Files may still be affected by disk errors, permissions, or interruptions during a move. Back up important data before running the tool.
- Do not organize active software projects, application directories, or system folders. Moving source files out of their project structure can break applications.
- Review the PowerShell source code before running it.

## Troubleshooting

### The script does not run

Ensure that both files are present and that `OrganizeFiles.bat` points to `OrganizeFiles.ps1` in the same directory.

### Access is denied

Choose a folder where your Windows account has permission to move files. Avoid protected system directories.

### Some files are not organized

Check whether their extensions are included in the configured mapping.

### Duplicate files are skipped

Rename or manually review the conflicting files if you want to organize them separately. The tool does not overwrite existing destination files.

## Contributing

Contributions are welcome.

1. Fork this repository.
2. Create a feature branch.
3. Make and test your changes.
4. Submit a pull request describing the changes.

Please test changes on sample files before using them on important data.

## License

This project is intended to be distributed under the MIT License. Add a `LICENSE` file containing the standard MIT License text and your chosen copyright holder and year before publishing.

---

**Windows File Organizer** — Simple, practical file organization for Windows.
