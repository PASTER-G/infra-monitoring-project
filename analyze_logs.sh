#!/usr/bin/env bash

log_file="$(dirname "$0")/access.log"

for ((i = 0; i < 300; i++)); do
  case $((i % 10)) in
    0|1|2|3) ip=192.168.1.10 ;;
    4|5|6) ip=10.0.0.5 ;;
    7|8) ip=172.16.0.8 ;;
    9) ip=203.0.113.7 ;;
  esac

  case $((i % 6)) in
    0|1|2) method=GET; path=/api/users; code=200 ;;
    3) method=POST; path=/api/login; code=401 ;;
    4) method=GET; path=/api/missing; code=404 ;;
    5) method=GET; path=/api/health; code=500 ;;
  esac

  printf '%s - - [15/Aug/2026:10:15:%02d] "%s %s HTTP/1.1" %s\n' \
    "$ip" "$((i % 60))" "$method" "$path" "$code"
done > "$log_file"

printf 'Общее количество запросов: %s\n' "$(awk 'END { print NR }' "$log_file")"
printf 'Топ-3 IP-адреса:\n'
grep -Eo '^[0-9]{1,3}(\.[0-9]{1,3}){3}' "$log_file" | sort | uniq -c | sort -nr | head -3
printf 'Количество запросов с кодами 4xx: %s\n' "$(awk '$NF ~ /^4[0-9][0-9]$/ { count++ } END { print count+0 }' "$log_file")"
printf 'Количество запросов с кодами 5xx: %s\n' "$(awk '$NF ~ /^5[0-9][0-9]$/ { count++ } END { print count+0 }' "$log_file")"
