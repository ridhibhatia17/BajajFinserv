# PowerShell Script to Test Google Gemini AI Integration
# Tests AI endpoint with various scenarios

$baseUrl = "http://localhost:3000/bfhl"
$testResults = @()
$passCount = 0
$failCount = 0

function Test-AIEndpoint {
    param(
        [string]$TestName,
        [string]$Question,
        [string]$ExpectedStatus = "200"
    )
    
    Write-Host ""
    Write-Host "=== Testing: $TestName ===" -ForegroundColor Cyan
    Write-Host "Question: $Question" -ForegroundColor Gray
    
    try {
        $body = @{ AI = $Question } | ConvertTo-Json
        
        $response = Invoke-WebRequest -Uri $baseUrl -Method POST -Body $body -ContentType "application/json" -UseBasicParsing -ErrorAction Stop
        
        $result = $response.Content | ConvertFrom-Json
        Write-Host "Response: $($response.Content)" -ForegroundColor Green
        Write-Host "AI Answer: $($result.data)" -ForegroundColor Yellow
        
        # Verify it's a single word
        $wordCount = ($result.data -split '\s+').Count
        if ($wordCount -eq 1) {
            Write-Host "Single word verification: PASS (1 word)" -ForegroundColor Green
        } else {
            Write-Host "Single word verification: FAIL ($wordCount words)" -ForegroundColor Red
        }
        
        Write-Host "Status: $($response.StatusCode) PASS" -ForegroundColor Green
        
        $script:testResults += @{
            Test = $TestName
            Status = "PASS"
            Question = $Question
            Answer = $result.data
            WordCount = $wordCount
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
Write-Host "   GOOGLE GEMINI AI INTEGRATION TEST     " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# ============================================
# SIMPLE QUESTIONS
# ============================================
Write-Host ""
Write-Host "SIMPLE QUESTIONS" -ForegroundColor Magenta

Test-AIEndpoint -TestName "Greeting" -Question "Hello"
Test-AIEndpoint -TestName "Simple Question" -Question "What is AI?"
Test-AIEndpoint -TestName "Yes/No Question" -Question "Is the sky blue?"
Test-AIEndpoint -TestName "Name Question" -Question "What is your name?"
Test-AIEndpoint -TestName "Time Question" -Question "What time is it?"

# ============================================
# COMPLEX QUESTIONS
# ============================================
Write-Host ""
Write-Host "COMPLEX QUESTIONS" -ForegroundColor Magenta

Test-AIEndpoint -TestName "Complex Description" -Question "Explain quantum computing in detail"
Test-AIEndpoint -TestName "Long Question" -Question "Can you tell me everything about the history of computers?"
Test-AIEndpoint -TestName "Math Question" -Question "What is 2+2?"
Test-AIEndpoint -TestName "Location Question" -Question "Where is Paris?"

# ============================================
# EDGE CASES
# ============================================
Write-Host ""
Write-Host "EDGE CASES" -ForegroundColor Magenta

Test-AIEndpoint -TestName "Single Word" -Question "Help"
Test-AIEndpoint -TestName "Numbers" -Question "123"
Test-AIEndpoint -TestName "Special Characters" -Question "!@#$%"
Test-AIEndpoint -TestName "Very Long Question" -Question "This is a very long question that contains many words and spans multiple sentences and should still return only a single word answer from the AI service."

# ============================================
# VALIDATION TESTS
# ============================================
Write-Host ""
Write-Host "VALIDATION TESTS" -ForegroundColor Magenta

Test-AIEndpoint -TestName "Empty String" -Question "" -ExpectedStatus "400"

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

Write-Host ""
Write-Host "SINGLE WORD VERIFICATION:" -ForegroundColor Yellow
$singleWordTests = $testResults | Where-Object { $_.WordCount -ne $null }
$singleWordPass = ($singleWordTests | Where-Object { $_.WordCount -eq 1 }).Count
$singleWordTotal = $singleWordTests.Count
Write-Host "Single word responses: $singleWordPass / $singleWordTotal" -ForegroundColor $(if ($singleWordPass -eq $singleWordTotal) { "Green" } else { "Yellow" })

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
