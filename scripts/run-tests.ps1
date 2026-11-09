# GymBuddy Universal Automated QA Test Runner (PowerShell)
# Usage: powershell -ExecutionPolicy Bypass -File .\scripts\run-tests.ps1

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   GYMBUDDY UNIVERSAL MOBILE QA AUTOMATION RUNNER        " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Environment Diagnostics
Write-Host "[1/5] Verifying toolchain and device environment..." -ForegroundColor Yellow
flutter --version
adb devices

# 2. Static Code Analysis
Write-Host "[2/5] Running static analysis..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "reports/qa/logs" | Out-Null
flutter analyze *>&1 | Tee-Object -FilePath "reports/qa/logs/analysis.log"
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Static analysis reported issues. Check reports/qa/logs/analysis.log"
}

# 3. Unit, Widget, and Screen Coverage Testing
Write-Host "[3/5] Executing full automated test suite with coverage..." -ForegroundColor Yellow
flutter test --coverage *>&1 | Tee-Object -FilePath "reports/qa/logs/unit-tests.log"
$TestExitCode = $LASTEXITCODE

# 4. Generate Reports and Evidence Manifests
Write-Host "[4/5] Generating reports and aggregating metrics..." -ForegroundColor Yellow
python scripts/generate-report.py

# 5. Summary & Verdict
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "QA Execution Finished!" -ForegroundColor Green
Write-Host "Report Archive: artifacts/mobile-app-qa-report.zip" -ForegroundColor White
Write-Host "Executive Summary: reports/qa/EXECUTIVE-SUMMARY.md" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Green

exit $TestExitCode
