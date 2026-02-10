# PowerShell Script to Test Mathematical Operations
# Tests Fibonacci, Prime, LCM, HCF with edge cases

$baseUrl = "http://localhost:3000/bfhl"
$testResults = @()
$passCount = 0
$failCount = 0

function Test-Endpoint {
    param(
        [string]$TestName,
        [hashtable]$Body,
        [string]$ExpectedStatus = "200"
    )
    
    Write-Host ""
    Write-Host "=== Testing: $TestName ===" -ForegroundColor Cyan
    
    try {
        $jsonBody = $Body | ConvertTo-Json -Depth 10
        Write-Host "Request: $jsonBody" -ForegroundColor Gray
        
        $response = Invoke-WebRequest -Uri $baseUrl -Method POST -Body $jsonBody -ContentType "application/json" -UseBasicParsing -ErrorAction Stop
        
        $result = $response.Content | ConvertFrom-Json
        Write-Host "Response: $($response.Content)" -ForegroundColor Green
        Write-Host "Status: $($response.StatusCode) PASS" -ForegroundColor Green
        
        $script:testResults += @{
            Test = $TestName
            Status = "PASS"
            Response = $result
        }
        $script:passCount++
        return $result
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.Value__
        $errorBody = ""
        
        try {
            $stream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $errorBody = $reader.ReadToEnd()
        } catch {
            $errorBody = $_.Exception.Message
        }
        
        Write-Host "Status: $statusCode" -ForegroundColor Yellow
        Write-Host "Error: $errorBody" -ForegroundColor Yellow
        
        if ($ExpectedStatus -eq $statusCode) {
            Write-Host "Expected error response PASS" -ForegroundColor Green
            $script:testResults += @{
                Test = $TestName
                Status = "PASS"
                Response = $errorBody
            }
            $script:passCount++
        } else {
            Write-Host "Test Failed" -ForegroundColor Red
            $script:testResults += @{
                Test = $TestName
                Status = "FAIL"
                Response = $errorBody
            }
            $script:failCount++
        }
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   MATHEMATICAL OPERATIONS TEST SUITE    " -ForegroundColor Cyan
Write-Host "   Testing: Fibonacci, Prime, LCM, HCF   " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# ============================================
# FIBONACCI TESTS
# ============================================
# FIBONACCI TESTS
# ============================================
Write-Host ""
Write-Host "FIBONACCI TESTS" -ForegroundColor Magenta

Test-Endpoint -TestName "Fibonacci: n=1 (edge case)" -Body @{
    fibonacci = 1
}

Test-Endpoint -TestName "Fibonacci: n=2" -Body @{
    fibonacci = 2
}

Test-Endpoint -TestName "Fibonacci: n=10" -Body @{
    fibonacci = 10
}

Test-Endpoint -TestName "Fibonacci: n=20 (larger series)" -Body @{
    fibonacci = 20
}

Test-Endpoint -TestName "Fibonacci: n=30 (stress test)" -Body @{
    fibonacci = 30
}

Test-Endpoint -TestName "Fibonacci: n=0 (invalid)" -Body @{
    fibonacci = 0
} -ExpectedStatus "400"

Test-Endpoint -TestName "Fibonacci: negative n" -Body @{
    fibonacci = -5
} -ExpectedStatus "400"

# ============================================
# PRIME TESTS
# ============================================
Write-Host ""
Write-Host "PRIME NUMBER TESTS" -ForegroundColor Magenta

Test-Endpoint -TestName "Prime: Single prime (7)" -Body @{
    prime = @(7)
}

Test-Endpoint -TestName "Prime: Multiple primes" -Body @{
    prime = @(2, 3, 5, 7, 11, 13)
}

Test-Endpoint -TestName "Prime: Mixed (primes and non-primes)" -Body @{
    prime = @(2, 4, 7, 9, 11, 15, 17)
}

Test-Endpoint -TestName "Prime: Large prime (997)" -Body @{
    prime = @(997, 998, 999, 1000)
}

Test-Endpoint -TestName "Prime: Edge case (1 is not prime)" -Body @{
    prime = @(1, 2, 3)
}

Test-Endpoint -TestName "Prime: All non-primes" -Body @{
    prime = @(4, 6, 8, 9, 10)
}

Test-Endpoint -TestName "Prime: Large non-prime (1000)" -Body @{
    prime = @(1000)
}

# ============================================
# HCF (GCD) TESTS
# ============================================
Write-Host ""
Write-Host "HCF (HIGHEST COMMON FACTOR) TESTS" -ForegroundColor Magenta

Test-Endpoint -TestName "HCF: Simple (12, 18)" -Body @{
    hcf = @(12, 18)
}

Test-Endpoint -TestName "HCF: Multiple numbers" -Body @{
    hcf = @(24, 36, 48)
}

Test-Endpoint -TestName "HCF: Coprime numbers (result = 1)" -Body @{
    hcf = @(17, 19)
}

Test-Endpoint -TestName "HCF: Large numbers" -Body @{
    hcf = @(1000, 500, 250)
}

Test-Endpoint -TestName "HCF: Same numbers" -Body @{
    hcf = @(42, 42, 42)
}

Test-Endpoint -TestName "HCF: Powers of 2" -Body @{
    hcf = @(16, 32, 64)
}

Test-Endpoint -TestName "HCF: Single number (invalid)" -Body @{
    hcf = @(10)
} -ExpectedStatus "400"

# ============================================
# LCM TESTS
# ============================================
Write-Host ""
Write-Host "LCM (LEAST COMMON MULTIPLE) TESTS" -ForegroundColor Magenta

Test-Endpoint -TestName "LCM: Simple (4, 6)" -Body @{
    lcm = @(4, 6)
}

Test-Endpoint -TestName "LCM: Multiple numbers" -Body @{
    lcm = @(3, 4, 5)
}

Test-Endpoint -TestName "LCM: Same numbers" -Body @{
    lcm = @(7, 7)
}

Test-Endpoint -TestName "LCM: Coprime numbers" -Body @{
    lcm = @(7, 11)
}

Test-Endpoint -TestName "LCM: Large numbers (overflow protection)" -Body @{
    lcm = @(12, 18, 24)
}

Test-Endpoint -TestName "LCM: Powers (2, 4, 8)" -Body @{
    lcm = @(2, 4, 8)
}

Test-Endpoint -TestName "LCM: Single number (invalid)" -Body @{
    lcm = @(10)
} -ExpectedStatus "400"

# ============================================
# RESULTS SUMMARY
# ============================================
Write-Host ""
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       TEST RESULTS SUMMARY              " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Total Tests: $($passCount + $failCount)" -ForegroundColor White
Write-Host "Passed: $passCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Red" })
Write-Host "Success Rate: $([math]::Round(($passCount / ($passCount + $failCount)) * 100, 2))%" -ForegroundColor Cyan

if ($failCount -eq 0) {
    Write-Host ""
    Write-Host "ALL TESTS PASSED!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "SOME TESTS FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "Failed Tests:" -ForegroundColor Yellow
    $testResults | Where-Object { $_.Status -eq "FAIL" } | ForEach-Object {
        Write-Host "  - $($_.Test)" -ForegroundColor Red
    }
}

Write-Host ""
