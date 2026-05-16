#!/bin/bash
# ========================================
# check_cpu.sh - CPU Usage Monitor
# ========================================

source "$HOME/server-health-monitor/config.conf"

check_cpu() {
    # Ambil CPU usage (average 1 saat)
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'.' -f1)

    if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
        echo "❌ CPU Usage   : ${CPU_USAGE}% — WARNING! (threshold: ${CPU_THRESHOLD}%)"
        return 1
    else
        echo "✅ CPU Usage   : ${CPU_USAGE}%"
        return 0
    fi
}

check_cpu
