#! /bin/bash

source "..."

DISK="..."

FILE_LOG_PATH="..."

HOSTNAME=$HOSTNAME

TIMESTAMP=$(TZ=America/Sao_Paulo date +"%Y-%m-%d %H:%M:%S")

DISK_SIZE_BYTES=$(df -B1 "$DISK" | awk 'NR==2 {print $2}')

DISK_SIZE_USED_BYTES=$(df -B1 "$DISK" | awk 'NR==2 {print $3}')

DISK_USAGE_PERCENT=$(($DISK_SIZE_USED_BYTES * 100 / $DISK_SIZE_BYTES))

JSON_MESSAGE=$(cat <<EOF
    {
        "hostname": "$HOSTNAME",
        "disk": "$DISK",
        "usage_percent": "$DISK_USAGE_PERCENT"
    }
EOF
)

if [ $DISK_USAGE_PERCENT -gt 50 ]; then

    echo "[INFO] $TIMESTAMP crontab executed" >> $FILE_LOG_PATH
    echo "[WARN] ALARM DISK USAGE ABOVE 5%: hostname: $HOSTNAME disk usage: $DISK_USAGE_PERCENT%" >> $FILE_LOG_PATH

    aws sns publish --topic-arn "$SNS_ARN" --message "$JSON_MESSAGE"

else

    echo "[INFO] $TIMESTAMP crontab executed" >> $FILE_LOG_PATH
    echo "[INFO] OK DISK USAGE UNDER 5% hostname: $HOSTNAME disk usage: $DISK_USAGE_PERCENT%" >> $FILE_LOG_PATH

fi