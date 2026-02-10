# Simple Security Test
$baseUrl = "http://localhost:3000"
Write-Host "Testing Security Features..." -ForegroundColor Cyan

# Test 1: Missing Content-Type (expect 415)
try {
    Invoke-WebRequest -Uri "$baseUrl/bfhl" -Method POST -Body '{"AI":"test"}' -UseBasicParsing
    Write-Host "Test 1 FAILED: Should reject missing content-type" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 415) {
        Write-Host "✓ Test 1 PASSED: Content-type validation works" -ForegroundColor Green
    } else {
        Write-Host "Test 1 FAILED: Wrong status code $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    }
}

# Test 2: Correct Content-Type (expect 200)
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/bfhl" -Method POST -ContentType "application/json" -Body '{"AI":"test"}' -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Test 2 PASSED: Valid request works" -ForegroundColor Green
    }
} catch {
    Write-Host "Test 2 FAILED: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
}

# Test 3: Empty Body (expect 400)
try {
    Invoke-WebRequest -Uri "$baseUrl/bfhl" -Method POST -ContentType "application/json" -Body "" -UseBasicParsing
    Write-Host "Test 3 FAILED: Should reject empty body" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 400) {
        Write-Host "✓ Test 3 PASSED: Empty body protection works" -ForegroundColor Green
    } else {
        Write-Host "Test 3 FAILED: Wrong status code" -ForegroundColor Red
    }
}

# Test 4: Prototype Pollution (expect 400)
try {
    Invoke-WebRequest -Uri "$baseUrl/bfhl" -Method POST -ContentType "application/json" -Body '{"__proto__":{"admin":true},"AI":"test"}' -UseBasicParsing
    Write-Host "Test 4 FAILED: Should block prototype pollution" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 400) {
        Write-Host "✓ Test 4 PASSED: Prototype pollution blocked" -ForegroundColor Green
    } else {
        Write-Host "Test 4 FAILED: Wrong status code" -ForegroundColor Red
    }
}

# Test 5: Health endpoint (expect 200)
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/health" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Test 5 PASSED: Health endpoint works" -ForegroundColor Green
    }
} catch {
    Write-Host "Test 5 FAILED" -ForegroundColor Red
}

Write-Host "`nSecurity tests completed!" -ForegroundColor Cyan
