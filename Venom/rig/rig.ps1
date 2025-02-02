# URL of the file to download
$url = "https://xmrig.com/download"

# Path to save the downloaded file
$output = "$currentDirectory/xmrig-6.22.2.zip"

# Create Internet Explorer COM object
$ie = New-Object -ComObject "InternetExplorer.Application"
$ie.Visible = $false

# Navigate to the URL
$ie.Navigate($url)

# Wait for the download to complete (simple delay, adjust as needed)
Start-Sleep -Seconds 30

# Save the file
$ie.Document.body.InnerHtml | Out-File -FilePath $output

# Quit Internet Explorer
$ie.Quit()
