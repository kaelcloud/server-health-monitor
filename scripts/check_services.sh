#!/bin/bash
# ========================================
# check_services.sh - Service Status Monitor
# ========================================

source "$HOME/server-health-monitor/config.conf"

check_services() {
    STATUS=0

    for SERVICE in $SERVICES; do
        # Check sama ada service running
        if service "$SERVICE" status 2>/dev/null | grep -q "running\|active"; then
            echo "✅ Service     : $SERVICE is running"
        else
            echo "❌ Service     : $SERVICE is STOPPED — WARNING!"
            STATUS=1
        fi
    done

    return $STATUS
}

check_services
