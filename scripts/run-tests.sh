#!/usr/bin/env bash
# GymBuddy Universal Automated QA Test Runner (Bash)
# Usage: ./scripts/run-tests.sh

set -e

echo "=========================================================="
echo "   GYMBUDDY UNIVERSAL MOBILE QA AUTOMATION RUNNER        "
echo "=========================================================="

# 1. Environment Diagnostics
echo "[1/5] Verifying toolchain and device environment..."
flutter --version
adb devices

# 2. Static Code Analysis
echo "[2/5] Running static analysis..."
mkdir -p reports/qa/logs
flutter analyze 2>&1 | tee reports/qa/logs/analysis.log || true

# 3. Unit, Widget, and Screen Coverage Testing
echo "[3/5] Executing full automated test suite with coverage..."
flutter test --coverage 2>&1 | tee reports/qa/logs/unit-tests.log

# 4. Generate Reports and Evidence Manifests
echo "[4/5] Generating reports and aggregating metrics..."
python3 scripts/generate-report.py || python scripts/generate-report.py

# 5. Summary & Verdict
echo "=========================================================="
echo "QA Execution Finished!"
echo "Report Archive: artifacts/mobile-app-qa-report.zip"
echo "Executive Summary: reports/qa/EXECUTIVE-SUMMARY.md"
echo "=========================================================="
