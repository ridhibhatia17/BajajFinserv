# Production Security Features Test Suite
$baseUrl = "http://localhost:3000"
$testsPassed = 0
$testsFailed = 0

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Production Security Features Test Suite" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

function Test-Request {
    param(
        [string]$Name,
        [hashtable]$Params,
        [int]$ExpectedStatus
    )
    
    Write-Host "Testing: $Name" -ForegroundColor Yellow
    
    try {
        $response = Invoke-WebRequest @Params -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq $ExpectedStatus) {
            Write-Host "  ✓ PASS" -ForegroundColor Green
            $script:testsPassed++
        } else {
            Write-Host "  ✗ FAIL: Expected $ExpectedStatus, got $($response.StatusCode)" -ForegroundColor Red
            $script:testsFailed++
        }
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq $ExpectedStatus) {
            Write-Host "  ✓ PASS" -ForegroundColor Green
            $script:testsPassed++
        } else {
            Write-Host "  ✗ FAIL: Expected $ExpectedStatus, got $statusCode" -ForegroundColor Red
            $script:testsFailed++
        }
    }
    Write-Host ""
}

# TEST 1: Missing Content-Type
Write-Host "`n--- Content-Type Validation ---`n" -ForegroundColor Magenta
Test-Request -Name "Missing Content-Type" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; Body='{"data":["A"],"AI":"test"}'} `
             -ExpectedStatus 415

# TEST 2: Wrong Content-Type
Test-Request -Name "Wrong Content-Type" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="text/plain"; Body='{"data":["A"],"AI":"test"}'} `
             -ExpectedStatus 415

# TEST 3: Correct Content-Type
Test-Request -Name "Correct Content-Type" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body='{"data":["A"],"AI":"test"}'} `
             -ExpectedStatus 200

# TEST 4: Large Payload (>100KB)
Write-Host "`n--- Body Size Limit ---`n" -ForegroundColor Magenta
$largeArray = @()
for ($i = 0; $i -lt 10000; $i++) { $largeArray += "A$i" }
$largePayload = @{data=$largeArray; AI="test"} | ConvertTo-Json
Test-Request -Name "Payload >100KB" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body=$largePayload} `
             -ExpectedStatus 413

# TEST 5: Normal Payload
Test-Request -Name "Normal Payload <100KB" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body='{"data":["A","1"],"AI":"test"}'} `
             -ExpectedStatus 200

# TEST 6: Empty Body
Write-Host "`n--- Empty Body Prevention ---`n" -ForegroundColor Magenta
Test-Request -Name "Empty Body" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body=""} `
             -ExpectedStatus 400

# TEST 7: Empty JSON
Test-Request -Name "Empty JSON Object" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body="{}"} `
             -ExpectedStatus 400

# TEST 8: Prototype Pollution __proto__
Write-Host "`n--- Prototype Pollution Prevention ---`n" -ForegroundColor Magenta
Test-Request -Name "Injection via __proto__" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body='{"__proto__":{"admin":true},"data":["A"],"AI":"test"}'} `
             -ExpectedStatus 400

# TEST 9: Prototype Pollution constructor
Test-Request -Name "Injection via constructor" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body='{"constructor":{"admin":true},"data":["A"],"AI":"test"}'} `
             -ExpectedStatus 400

# TEST 10: Prototype Pollution prototype
Test-Request -Name "Injection via prototype" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body='{"prototype":{"admin":true},"data":["A"],"AI":"test"}'} `
             -ExpectedStatus 400

# TEST 11: AI Input >5000 chars
Write-Host "`n--- AI Input Sanitization ---`n" -ForegroundColor Magenta
$longString = "A" * 5001
$bodyWithLongAI = @{data=@("A","1"); AI=$longString} | ConvertTo-Json
Test-Request -Name "AI input >5000 chars" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body=$bodyWithLongAI} `
             -ExpectedStatus 400

# TEST 12: AI Input with HTML
Test-Request -Name "AI input with HTML (sanitized)" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body='{"data":["A"],"AI":"<script>alert(1)</script>test"}'} `
             -ExpectedStatus 200

# TEST 13: Regression - Valid Request
Write-Host "`n--- Regression Tests ---`n" -ForegroundColor Magenta
Test-Request -Name "Valid Request" `
             -Params @{Uri="$baseUrl/bfhl"; Method="POST"; ContentType="application/json"; Body='{"data":["A","C","1","3"],"AI":"What is 2+2?"}'} `
             -ExpectedStatus 200

# TEST 14: Health Endpoint
Test-Request -Name "Health Endpoint" `
             -Params @{Uri="$baseUrl/health"; Method="GET"} `
             -ExpectedStatus 200

# TEST 15: Security Headers
Write-Host "`n--- Security Headers ---`n" -ForegroundColor Magenta
Write-Host "Testing: Security Headers Present" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/health" -UseBasicParsing
    $headers = @("X-Content-Type-Options", "X-Frame-Options", "X-XSS-Protection", "Referrer-Policy")
    $allPresent = $true
    foreach ($h in $headers) {
        if (-not $response.Headers[$h]) { $allPresent = $false }
    }
    if ($allPresent) {
        Write-Host "  ✓ PASS" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "  ✗ FAIL: Missing headers" -ForegroundColor Red
        $testsFailed++
    }
}
catch {
    Write-Host "  ✗ FAIL: Could not check" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Test Results Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total Passed: $testsPassed" -ForegroundColor Green
Write-Host "Total Failed: $testsFailed" -ForegroundColor $(if ($testsFailed -eq 0) { "Green" } else { "Red" })
$successRate = [math]::Round(($testsPassed / ($testsPassed + $testsFailed)) * 100, 2)
Write-Host "Success Rate: $successRate%" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if ($testsFailed -eq 0) {
    Write-Host "✓ All security features working!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "✗ Some tests failed" -ForegroundColor Red
    exit 1
}
