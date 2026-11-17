#!/bin/bash

LOG_FILE="/nginx-logs/access.log"
SUMMARY_FILE="/logs/summary.txt"

mkdir -p /logs

if [ ! -f "$LOG_FILE" ]; then
    echo "ERROR: Nginx access log not found at $LOG_FILE"
    exit 1
fi

{
    echo "Nginx Access Log Summary"
    echo "Generated at: $(date)"
    echo "=========================="

    total_requests=$(wc -l < "$LOG_FILE")

    successful_requests=$(awk '$9 ~ /^2[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

    redirect_requests=$(awk '$9 ~ /^3[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

    client_errors=$(awk '$9 ~ /^4[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

    server_errors=$(awk '$9 ~ /^5[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

    echo "Total requests: $total_requests"
    echo "Successful requests (2xx): $successful_requests"
    echo "Redirect requests (3xx): $redirect_requests"
    echo "Client errors (4xx): $client_errors"
    echo "Server errors (5xx): $server_errors"

    echo ""
    echo "Recent requests:"
    tail -5 "$LOG_FILE"

} > "$SUMMARY_FILE"

echo "Nginx access log summary generated: $SUMMARY_FILE"
