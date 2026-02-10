# PowerShell Script - Complete API Test
# Tests all endpoints including Google Gemini AI

$baseUrl = "http://localhost:3000/bfhl"
$passCount = 0
$failCount = 0

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   COMPLETE API TEST - ALL OPERATIONS      " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

function Test-Request {
    param(
        [string]$Name,
        [hashtable]$Body
    )
    
    Write-Host ""
    Write-Host "Testing: $Name" -ForegroundColor Yellow
    
    try {
        $jsonBody = $Body | ConvertTo-Json
        $response = Invoke-WebRequest -Uri $baseUrl -Method POST -Body $jsonBody -ContentType "application/json" -UseBasicParsing -ErrorAction Stop
        $result = $response.Content | ConvertFrom-Json
        
        Write-Host "  Status: $($response.StatusCode) - PASS" -ForegroundColor Green
        Write-Host "  Result: $($result.data)" -ForegroundColor Gray
        $script:passCount++
    } catch {
        Write-Host "  Status: FAIL" -ForegroundColor Red
        $script:failCount++
    }
}

# Fibonacci
Test-Request -Name "Fibonacci (n=10)" -Body @{ fibonacci = 10 }

# Prime
Test-Request -Name "Prime Filter" -Body @{ prime = @(2, 3, 4, 5, 6, 7) }

# LCM
Test-Request -Name "LCM" -Body @{ lcm = @(12, 18, 24) }

# HCF
Test-Request -Name "HCF" -Body @{ hcf = @(36, 48, 60) }

# AI with Gemini
Test-Request -Name "AI: Hello" -Body @{ AI = "Hello" }
Test-Request -Name "AI: What is AI?" -Body @{ AI = "What is AI?" }
Test-Request -Name "AI: Name?" -Body @{ AI = "What is your name?" }

# Health Check
Write-Host ""
Write-Host "Testing: Health Check" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/health" -Method GET -UseBasicParsing -ErrorAction Stop
    Write-Host "  Status: $($response.StatusCode) - PASS" -ForegroundColor Green
    $script:passCount++
} catch {
    Write-Host "  Status: FAIL" -ForegroundColor Red
    $script:failCount++
}

# Summary
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Total: $($passCount + $failCount) | Passed: $passCount | Failed: $failCount" -ForegroundColor White
if ($failCount -eq 0) {
    Write-Host "ALL TESTS PASSED!" -ForegroundColor Green
} else {
    Write-Host "SOME TESTS FAILED" -ForegroundColor Red
}
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
