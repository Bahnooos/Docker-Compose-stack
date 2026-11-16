
#!/bin/bash

LOG_DIR="/logs"
SUMMARY_FILE="$LOG_DIR/summary.txt"

SERVICES=("app" "nginx" "postgres" "redis")

mkdir -p "$LOG_DIR"

{
    echo "Docker Log Summary"
    echo "Generated at: $(date)"
    echo "=========================="

    for service in "${SERVICES[@]}"; do
        echo ""
        echo "Service: $service"

        logs=$(docker logs "$service" 2>&1)

        total_lines=$(echo "$logs" | wc -l)
        error_count=$(echo "$logs" | grep -iE '(^|[[:space:]])(error|exception|fatal)(:|[[:space:]]|$)' | wc -l)
        echo "Total log lines: $total_lines"
        echo "Error count: $error_count"

        if [ "$error_count" -gt 0 ]; then
            echo "Recent errors:"
            echo "$logs" | grep -iE "error|exception|fatal" | tail -5
        fi
    done

} > "$SUMMARY_FILE"

echo "Log summary generated: $SUMMARY_FILE"
