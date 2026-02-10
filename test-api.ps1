# PowerShell script to test all API endpoints
# Run this script to verify all endpoints are working correctly

Write-Host "`n=== BFHL API Testing Script ===" -ForegroundColor Cyan
Write-Host "Testing API at http://localhost:3000`n" -ForegroundColor Cyan

# Test 1: Health Check
Write-Host "Test 1: GET /health" -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:3000/health" -Method GET -UseBasicParsing
Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
Write-Host "Response: $($response.Content)" -ForegroundColor White
Write-Host ""

# Test 2: Fibonacci
Write-Host "Test 2: POST /bfhl - Fibonacci(10)" -ForegroundColor Yellow
$body = '{"fibonacci": 10}'
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 3: Prime Numbers
Write-Host "Test 3: POST /bfhl - Prime Filter" -ForegroundColor Yellow
$body = '{"prime": [1,2,3,4,5,6,7,8,9,10]}'
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 4: LCM
Write-Host "Test 4: POST /bfhl - LCM([12,18,24])" -ForegroundColor Yellow
$body = '{"lcm": [12,18,24]}'
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 5: HCF
Write-Host "Test 5: POST /bfhl - HCF([12,18,24])" -ForegroundColor Yellow
$body = '{"hcf": [12,18,24]}'
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 6: AI
Write-Host "Test 6: POST /bfhl - AI Question" -ForegroundColor Yellow
$body = '{"AI": "What is your name?"}'
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 7: Error - Empty Body
Write-Host "Test 7: POST /bfhl - Empty Body (Error Test)" -ForegroundColor Yellow
$body = '{}'
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = $_.ErrorDetails.Message
    Write-Host "Status: $statusCode (Expected Error)" -ForegroundColor Yellow
    Write-Host "Response: $errorBody" -ForegroundColor White
}
Write-Host ""

# Test 8: Error - Multiple Keys
Write-Host "Test 8: POST /bfhl - Multiple Keys (Error Test)" -ForegroundColor Yellow
$body = '{"fibonacci": 10, "prime": [1,2,3]}'
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = $_.ErrorDetails.Message
    Write-Host "Status: $statusCode (Expected Error)" -ForegroundColor Yellow
    Write-Host "Response: $errorBody" -ForegroundColor White
}
Write-Host ""

# Test 9: Error - Invalid Key
Write-Host "Test 9: POST /bfhl - Invalid Key (Error Test)" -ForegroundColor Yellow
$body = '{"invalid": 10}'
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = $_.ErrorDetails.Message
    Write-Host "Status: $statusCode (Expected Error)" -ForegroundColor Yellow
    Write-Host "Response: $errorBody" -ForegroundColor White
}
Write-Host ""

# Test 10: Error - 404 Route
Write-Host "Test 10: GET /invalid-route - 404 (Error Test)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/invalid-route" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor White
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $errorBody = $_.ErrorDetails.Message
    Write-Host "Status: $statusCode (Expected Error)" -ForegroundColor Yellow
    Write-Host "Response: $errorBody" -ForegroundColor White
}
Write-Host ""

Write-Host "=== All Tests Complete ===" -ForegroundColor Cyan
