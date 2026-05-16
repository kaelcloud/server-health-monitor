#!/bin/bash
# ========================================
# monitor.sh - Main Server Health Monitor
# Simulates production monitoring routine
# ========================================

source "$HOME/server-health-monitor/config.conf"

# Warna terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# ----------------------------------------
# Header
# ----------------------------------------
echo -e "${CYAN}"
echo "========================================"
echo "   SERVER HEALTH MONITOR v1.0"
echo "   $TIMESTAMP"
echo "========================================"
echo -e "${NC}"

# ----------------------------------------
# Run semua checks
# ----------------------------------------
OVERALL_STATUS=0

echo -e "${CYAN}[ SYSTEM RESOURCES ]${NC}"
bash "$HOME/server-health-monitor/scripts/check_cpu.sh"
[ $? -ne 0 ] && OVERALL_STATUS=1

bash "$HOME/server-health-monitor/scripts/check_memory.sh"
[ $? -ne 0 ] && OVERALL_STATUS=1

bash "$HOME/server-health-monitor/scripts/check_disk.sh"
[ $? -ne 0 ] && OVERALL_STATUS=1

echo ""
echo -e "${CYAN}[ SERVICES ]${NC}"
bash "$HOME/server-health-monitor/scripts/check_services.sh"
[ $? -ne 0 ] && OVERALL_STATUS=1

echo ""
echo -e "${CYAN}[ LOG ANALYSIS ]${NC}"
bash "$HOME/server-health-monitor/scripts/check_logs.sh"
[ $? -ne 0 ] && OVERALL_STATUS=1

# ----------------------------------------
# Summary
# ----------------------------------------
echo ""
echo "========================================"
if [ $OVERALL_STATUS -eq 0 ]; then
    echo -e "${GREEN}   ✅ ALL SYSTEMS HEALTHY${NC}"
else
    echo -e "${RED}   ❌ WARNING: ISSUES DETECTED${NC}"
fi
echo "========================================"

# ----------------------------------------
# Simpan log
# ----------------------------------------
echo "[$TIMESTAMP] Monitor run completed — Status: $([ $OVERALL_STATUS -eq 0 ] && echo 'HEALTHY' || echo 'WARNING')" >> "$MONITOR_LOG"

exit $OVERALL_STATUS
