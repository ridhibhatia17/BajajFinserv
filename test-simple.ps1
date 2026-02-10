$baseUrl = "http://localhost:3000"

# Test: Simple valid request
Write-Host "Testing valid request with data and AI..." -ForegroundColor Yellow
$body = @{
    data = @("A", "1")
    AI = "test"
} | ConvertTo-Json
Write-Host "Request Body: $body" -ForegroundColor White

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/bfhl" -Method POST -ContentType "application/json" -Body $body -UseBasicParsing
    Write-Host "✓ Success! Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "✗ Failed! Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    $stream = $_.Exception.Response.GetResponseStream()
    $reader = [System.IO.StreamReader]::new($stream)
    $errorBody = $reader.ReadToEnd()
    Write-Host "Error Response: $errorBody" -ForegroundColor White
}
