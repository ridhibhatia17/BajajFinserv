# PowerShell script to test strict validation rules
# Tests all edge cases and error scenarios

Write-Host "`n=== STRICT VALIDATION TEST SUITE ===" -ForegroundColor Cyan
Write-Host "Testing enhanced validation at http://localhost:3000`n" -ForegroundColor Cyan

$successCount = 0
$failCount = 0

function Test-Endpoint {
    param(
        [string]$TestName,
        [string]$Body,
        [int]$ExpectedStatus,
        [string]$Description
    )
    
    Write-Host "Test: $TestName" -ForegroundColor Yellow
    Write-Host "Description: $Description" -ForegroundColor Gray
    Write-Host "Request Body: $Body" -ForegroundColor Gray
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $Body -ContentType "application/json" -UseBasicParsing -ErrorAction Stop
        Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "Response: $($response.Content)" -ForegroundColor White
        
        if ($response.StatusCode -eq $ExpectedStatus) {
            Write-Host "PASS" -ForegroundColor Green
            $script:successCount++
        } else {
            Write-Host "FAIL - Expected status $ExpectedStatus" -ForegroundColor Red
            $script:failCount++
        }
    } catch {
        $statusCode = 0
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
        }
        $errorBody = if ($_.ErrorDetails.Message) { $_.ErrorDetails.Message } else { $_.Exception.Message }
        
        if ($statusCode -eq $ExpectedStatus) {
            Write-Host "Status: $statusCode" -ForegroundColor Yellow
            Write-Host "Response: $errorBody" -ForegroundColor White
            Write-Host "PASS" -ForegroundColor Green
            $script:successCount++
        } else {
            Write-Host "Status: $statusCode" -ForegroundColor Red
            Write-Host "Response: $errorBody" -ForegroundColor White
            Write-Host "FAIL - Expected status $ExpectedStatus, got $statusCode" -ForegroundColor Red
            $script:failCount++
        }
    }
    Write-Host ""
}

# ===== TEST 1: Empty Body =====
Test-Endpoint -TestName "Empty Body" -Body '{}' -ExpectedStatus 400 -Description "Request with empty JSON object"

# ===== TEST 2: Multiple Keys =====
Test-Endpoint -TestName "Multiple Keys (2)" -Body '{"fibonacci": 10, "prime": [1,2,3]}' -ExpectedStatus 400 -Description "Request with 2 keys"

Test-Endpoint -TestName "Multiple Keys (3)" -Body '{"fibonacci": 10, "prime": [1,2,3], "AI": "test"}' -ExpectedStatus 400 -Description "Request with 3 keys"

# ===== TEST 3: Invalid Keys =====
Test-Endpoint -TestName "Invalid Key" -Body '{"invalid": 10}' -ExpectedStatus 400 -Description "Request with non-existent key"

Test-Endpoint -TestName "Typo in Key" -Body '{"Fibonacci": 10}' -ExpectedStatus 400 -Description "Request with wrong case key"

# ===== TEST 4: Wrong Data Types =====
Test-Endpoint -TestName "Fibonacci as String" -Body '{"fibonacci": "10"}' -ExpectedStatus 400 -Description "fibonacci with string value"

Test-Endpoint -TestName "Fibonacci as Float" -Body '{"fibonacci": 10.5}' -ExpectedStatus 400 -Description "fibonacci with decimal value"

Test-Endpoint -TestName "Prime as Object" -Body '{"prime": {"data": [1,2,3]}}' -ExpectedStatus 400 -Description "prime with object instead of array"

Test-Endpoint -TestName "LCM as String" -Body '{"lcm": "12,18"}' -ExpectedStatus 400 -Description "lcm with string instead of array"

Test-Endpoint -TestName "AI as Number" -Body '{"AI": 123}' -ExpectedStatus 400 -Description "AI with number instead of string"

# ===== TEST 5: Null and Undefined =====
Test-Endpoint -TestName "Null Value" -Body '{"fibonacci": null}' -ExpectedStatus 400 -Description "Request with null value"

# ===== TEST 6: Negative Numbers =====
Test-Endpoint -TestName "Negative Fibonacci" -Body '{"fibonacci": -5}' -ExpectedStatus 400 -Description "fibonacci with negative number"

Test-Endpoint -TestName "Negative in Prime Array" -Body '{"prime": [1, 2, -3, 4]}' -ExpectedStatus 400 -Description "prime array with negative number"

Test-Endpoint -TestName "Negative in LCM Array" -Body '{"lcm": [12, -18, 24]}' -ExpectedStatus 400 -Description "lcm array with negative number"

Test-Endpoint -TestName "Negative in HCF Array" -Body '{"hcf": [12, 18, -24]}' -ExpectedStatus 400 -Description "hcf array with negative number"

# ===== TEST 7: Zero Values =====
Test-Endpoint -TestName "Zero Fibonacci" -Body '{"fibonacci": 0}' -ExpectedStatus 400 -Description "fibonacci with zero"

Test-Endpoint -TestName "Zero in Prime Array" -Body '{"prime": [0, 1, 2]}' -ExpectedStatus 400 -Description "prime array with zero"

Test-Endpoint -TestName "Zero in LCM Array" -Body '{"lcm": [0, 12, 18]}' -ExpectedStatus 400 -Description "lcm array with zero"

# ===== TEST 8: Empty Arrays =====
Test-Endpoint -TestName "Empty Prime Array" -Body '{"prime": []}' -ExpectedStatus 400 -Description "prime with empty array"

Test-Endpoint -TestName "Empty LCM Array" -Body '{"lcm": []}' -ExpectedStatus 400 -Description "lcm with empty array"

Test-Endpoint -TestName "Empty HCF Array" -Body '{"hcf": []}' -ExpectedStatus 400 -Description "hcf with empty array"

# ===== TEST 9: Arrays with Single Element =====
Test-Endpoint -TestName "LCM Single Element" -Body '{"lcm": [12]}' -ExpectedStatus 400 -Description "lcm with only 1 element"

Test-Endpoint -TestName "HCF Single Element" -Body '{"hcf": [12]}' -ExpectedStatus 400 -Description "hcf with only 1 element"

# ===== TEST 10: Arrays with Non-Integer Values =====
Test-Endpoint -TestName "Prime Array with Float" -Body '{"prime": [1, 2.5, 3]}' -ExpectedStatus 400 -Description "prime array with decimal number"

Test-Endpoint -TestName "LCM Array with Float" -Body '{"lcm": [12.5, 18, 24]}' -ExpectedStatus 400 -Description "lcm array with decimal number"

Test-Endpoint -TestName "Prime Array with String" -Body '{"prime": [1, "2", 3]}' -ExpectedStatus 400 -Description "prime array with string element"

# ===== TEST 11: Empty Strings =====
Test-Endpoint -TestName "Empty AI String" -Body '{"AI": ""}' -ExpectedStatus 400 -Description "AI with empty string"

Test-Endpoint -TestName "Whitespace AI String" -Body '{"AI": "   "}' -ExpectedStatus 400 -Description "AI with only whitespace"

# ===== TEST 12: Special Values =====
Test-Endpoint -TestName "Fibonacci Infinity" -Body '{"fibonacci": Infinity}' -ExpectedStatus 400 -Description "fibonacci with Infinity"

Test-Endpoint -TestName "Fibonacci NaN" -Body '{"fibonacci": NaN}' -ExpectedStatus 400 -Description "fibonacci with NaN"

# ===== TEST 13: Array as Root =====
Test-Endpoint -TestName "Array Root" -Body '[{"fibonacci": 10}]' -ExpectedStatus 400 -Description "Array as root instead of object"

# ===== TEST 14: Valid Requests (Should Pass) =====
Write-Host "`n=== TESTING VALID REQUESTS ===" -ForegroundColor Magenta

Test-Endpoint -TestName "Valid Fibonacci" -Body '{"fibonacci": 10}' -ExpectedStatus 200 -Description "Valid fibonacci request"

Test-Endpoint -TestName "Valid Prime" -Body '{"prime": [1,2,3,4,5]}' -ExpectedStatus 200 -Description "Valid prime request"

Test-Endpoint -TestName "Valid LCM" -Body '{"lcm": [12, 18]}' -ExpectedStatus 200 -Description "Valid lcm request"

Test-Endpoint -TestName "Valid HCF" -Body '{"hcf": [12, 18, 24]}' -ExpectedStatus 200 -Description "Valid hcf request"

Test-Endpoint -TestName "Valid AI" -Body '{"AI": "What is your name?"}' -ExpectedStatus 200 -Description "Valid AI request"

# ===== SUMMARY =====
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "TEST SUMMARY" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Total Tests: $($successCount + $failCount)" -ForegroundColor White
Write-Host "Passed: $successCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Red" })
Write-Host "Success Rate: $([math]::Round(($successCount / ($successCount + $failCount)) * 100, 2))%" -ForegroundColor White
Write-Host "======================================`n" -ForegroundColor Cyan

if ($failCount -eq 0) {
    Write-Host "🎉 ALL TESTS PASSED! Server validation is strict and working correctly!" -ForegroundColor Green
} else {
    Write-Host "⚠ Some tests failed. Please review the output above." -ForegroundColor Yellow
}
