#!/bin/bash
# ========================================
# check_logs.sh - Log Analysis Monitor
# ========================================

source "$HOME/server-health-monitor/config.conf"

check_logs() {
    STATUS=0

    # Check sama ada log file wujud
    if [ ! -f "$LOG_FILE" ]; then
        echo "⚠️  Logs        : $LOG_FILE not found — skipping"
        return 0
    fi

    # Check errors dalam last 100 baris
    ERROR_COUNT=$(tail -100 "$LOG_FILE" | grep -ci "error\|critical\|failed" 2>/dev/null)

    # Check failed login attempts
    FAILED_LOGIN=$(tail -100 "$LOG_FILE" | grep -ci "failed password\|authentication failure" 2>/dev/null)

    # Check warnings
    WARN_COUNT=$(tail -100 "$LOG_FILE" | grep -ci "warning\|warn" 2>/dev/null)

    # Report errors
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo "❌ Logs        : $ERROR_COUNT error(s) found in $LOG_FILE — WARNING!"
        STATUS=1
    else
        echo "✅ Logs        : No errors found"
    fi

    # Report failed logins
    if [ "$FAILED_LOGIN" -gt 0 ]; then
        echo "❌ Logs        : $FAILED_LOGIN failed login attempt(s) detected — WARNING!"
        STATUS=1
    else
        echo "✅ Logs        : No failed login attempts"
    fi

    # Report warnings
    if [ "$WARN_COUNT" -gt 0 ]; then
        echo "⚠️  Logs        : $WARN_COUNT warning(s) found"
    else
        echo "✅ Logs        : No warnings"
    fi

    return $STATUS
}

check_logs
