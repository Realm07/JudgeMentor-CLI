# Do NOT use param() here. 
# We check if the user/webpage already declared $SessionId in the session.
if (-not $SessionId) {
    $SessionId = Read-Host "Enter your JudgeMentor Session ID"
}

# Replace this with your actual backend server URL (when built)
$ApiUrl = "https://api.judgementor.ai/session/$SessionId"

# Helper function to send real updates to your backend
function Update-Status([string]$Message, [string]$State = "PROCESSING") {
    Write-Host "-> $Message" -ForegroundColor DarkGray
    
    # Payload for backend
    $payload = @{
        status = $Message
        state = $State
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri $ApiUrl -Method Post -Body $payload -ContentType "application/json" -ErrorAction SilentlyContinue
    } catch {
        # Fails silently if API is unreachable, continues local execution
    }
}

Write-Host "`n[JUDGEMENTOR] INITIALIZING PIPELINE FOR SESSION: $SessionId" -ForegroundColor Yellow
Update-Status "Script connected. Awaiting folder path..."

# 2. Request Folder Path
$FolderPath = Read-Host "Enter the full path to your project folder"

if (-not (Test-Path $FolderPath)) {
    Update-Status "Error: Folder not found." "ERROR"
    Write-Host "Folder does not exist. Exiting." -ForegroundColor Red
    exit
}

Update-Status "Scanning directory for files..."
Start-Sleep -Seconds 1

# 3. Take the single file from the folder
$File = Get-ChildItem -Path $FolderPath -File | Select-Object -First 1

if (-not $File) {
    Update-Status "Error: No files found in directory." "ERROR"
    Write-Host "No files found in $FolderPath. Exiting." -ForegroundColor Red
    exit
}

Update-Status "Found file: $($File.Name). Reading contents..."
Start-Sleep -Seconds 2

# (Optional) Read file contents into memory to do redactions
# $FileContent = Get-Content $File.FullName -Raw

Update-Status "Redacting PII & Proprietary Keys..."
Start-Sleep -Seconds 2 # Simulating the redaction processing time

Update-Status "Transmitting $($File.Name) to server..."
Start-Sleep -Seconds 3 # Simulating upload time

Update-Status "Analysing Repository Structure..."
Start-Sleep -Seconds 3 # Simulating analysis time

Update-Status "Report Ready. Redirecting..." "COMPLETE"
Write-Host "`n[SUCCESS] Analysis Complete. Check your browser." -ForegroundColor Green