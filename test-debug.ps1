$baseUrl = "http://localhost:3000"

# Test 1: Check actual status code for missing content-type
Write-Host "Test 1: Missing Content-Type" -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri "$baseUrl/bfhl" -Method POST -Body '{\"data\":[\"A\"],\"AI\":\"test\"}' -UseBasicParsing
    Write-Host "Status: 200 (Unexpected - should be 415)" -ForegroundColor Red
} catch {
    $status = $_.Exception.Response.StatusCode.value__
    Write-Host "Status: $status" -ForegroundColor Cyan
    $stream = $_.Exception.Response.GetResponseStream()
    $reader = [System.IO.StreamReader]::new($stream)
    $body = $reader.ReadToEnd()
    Write-Host "Response: $body" -ForegroundColor White
}

Write-Host "`nTest 2: Correct Content-Type" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/bfhl" -Method POST -ContentType "application/json" -Body '{\"data\":[\"A\",\"1\"],\"AI\":\"test\"}' -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Cyan
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    $status = $_.Exception.Response.StatusCode.value__
    Write-Host "Status: $status (Error)" -ForegroundColor Red
    $stream = $_.Exception.Response.GetResponseStream()
    $reader = [System.IO.StreamReader]::new($stream)
    $body = $reader.ReadToEnd()
    Write-Host "Response: $body" -ForegroundColor White
}
