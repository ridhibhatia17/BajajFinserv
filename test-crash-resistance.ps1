# Test server crash resistance
Write-Host "`n=== SERVER CRASH RESISTANCE TEST ===" -ForegroundColor Cyan

$testCount = 0
$serverAlive = $true

function Test-ServerAlive {
    try {
        $health = Invoke-WebRequest -Uri "http://localhost:3000/health" -UseBasicParsing -TimeoutSec 5
        return $health.StatusCode -eq 200
    } catch {
        return $false
    }
}

function Test-CrashScenario {
    param([string]$Name, [string]$Body, [string]$ContentType = "application/json")
    
    $script:testCount++
    Write-Host "`nTest $testCount : $Name" -ForegroundColor Yellow
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body $Body -ContentType $ContentType -UseBasicParsing -TimeoutSec 5
        Write-Host "Response: $($response.StatusCode) - Server handled gracefully" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response) {
            Write-Host "Response: $($_.Exception.Response.StatusCode.value__) - Error handled gracefully" -ForegroundColor Green
        } else {
            Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    
    # Check if server is still alive
    Start-Sleep -Milliseconds 100
    if (-not (Test-ServerAlive)) {
        Write-Host "SERVER CRASHED!" -ForegroundColor Red
        $script:serverAlive = $false
        return $false
    } else {
        Write-Host "Server still alive" -ForegroundColor Green
        return $true
    }
}

# Test 1: Malformed JSON
Test-CrashScenario -Name "Malformed JSON (missing quote)" -Body '{"fibonacci: 10}'

# Test 2: Malformed JSON
Test-CrashScenario -Name "Malformed JSON (trailing comma)" -Body '{"fibonacci": 10,}'

# Test 3: Invalid JSON structure
Test-CrashScenario -Name "Invalid JSON (unclosed brace)" -Body '{"fibonacci": 10'

# Test 4: Very large number
Test-CrashScenario -Name "Very large fibonacci number" -Body '{"fibonacci": 99999999999999999999}'

# Test 5: Very large array
$largeArray = "[" + (1..10000 -join ",") + "]"
Test-CrashScenario -Name "Very large array (10000 elements)" -Body "{`"prime`": $largeArray}"

# Test 6: Deeply nested object
Test-CrashScenario -Name "Deeply nested object" -Body '{"fibonacci": {"nested": {"deep": {"value": 10}}}}'

# Test 7: Special characters in AI
Test-CrashScenario -Name "Special characters in AI" -Body '{"AI": "<script>alert(\"xss\")</script>"}'

# Test 8: Unicode characters
Test-CrashScenario -Name "Unicode characters" -Body '{"AI": "你好世界 🚀 emoji test"}'

# Test 9: SQL injection attempt
Test-CrashScenario -Name "SQL injection in AI" -Body '{"AI": "SELECT * FROM users; DROP TABLE users;--"}'

# Test 10: Empty content
Test-CrashScenario -Name "Empty body" -Body ''

# Test 11: Non-JSON content type
Test-CrashScenario -Name "Non-JSON content" -Body 'plain text body' -ContentType "text/plain"

# Test 12: Binary data
Test-CrashScenario -Name "Binary-like data" -Body ([char[]]@(0..255) -join '')

# Test 13: Extremely long string
$longString = "a" * 10000
Test-CrashScenario -Name "Very long AI string (10000 chars)" -Body "{`"AI`": `"$longString`"}"

# Test 14: Circular reference simulation
Test-CrashScenario -Name "Complex nested structure" -Body '{"prime": [[[[[[1,2,3]]]]]]}'

# Test 15: Mixed types in array
Test-CrashScenario -Name "Mixed types in prime array" -Body '{"prime": [1, "two", 3, null, true, {}, []]}'

# Test 16: Negative infinity
Test-CrashScenario -Name "Negative infinity" -Body '{"fibonacci": -Infinity}'

# Test 17: Scientific notation
Test-CrashScenario -Name "Scientific notation" -Body '{"fibonacci": 1e10}'

# Test 18: Boolean values
Test-CrashScenario -Name "Boolean in fibonacci" -Body '{"fibonacci": true}'

# Test 19: Multiple rapid requests
Write-Host "`nTest: Rapid sequential requests (stress test)" -ForegroundColor Yellow
for ($i = 1; $i -le 50; $i++) {
    try {
        Invoke-WebRequest -Uri "http://localhost:3000/bfhl" -Method POST -Body '{"fibonacci": 5}' -ContentType "application/json" -UseBasicParsing -TimeoutSec 2 | Out-Null
    } catch {}
}
if (Test-ServerAlive) {
    Write-Host "Server survived 50 rapid requests" -ForegroundColor Green
} else {
    Write-Host "Server crashed during stress test" -ForegroundColor Red
    $serverAlive = $false
}

# Final check
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "CRASH RESISTANCE SUMMARY" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Total Crash Tests: $testCount" -ForegroundColor White

if ($serverAlive) {
    Write-Host "Server Status: ALIVE AND STABLE" -ForegroundColor Green
    Write-Host "Result: SERVER NEVER CRASHED!" -ForegroundColor Green
    Write-Host "All error scenarios handled gracefully" -ForegroundColor Green
} else {
    Write-Host "Server Status: CRASHED" -ForegroundColor Red
    Write-Host "Result: Server crashed during testing" -ForegroundColor Red
}
Write-Host "======================================`n" -ForegroundColor Cyan
