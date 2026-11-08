#!/usr/bin/env bash

if [[ $# -ne 1 || -z "$1" ]]; then
  printf 'Использование: %s URL\n' "$0" >&2
  exit 1
fi

http_code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 -- "$1")
curl_status=$?

if [[ $curl_status -eq 0 && "$http_code" == 200 ]]; then
  printf 'API доступен\n'
  exit 0
fi

printf 'API недоступен, код ответа: %s\n' "${http_code:-000}"
exit 1
