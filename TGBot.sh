#!/bin/bash
ID=""
KEY=""

curl -s -X "POST" "https://api.telegram.org/bot$KEY/sendMessage" \
     -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
     --data-urlencode "text=${*:-"nya~"}" \
     --data-urlencode "chat_id=$ID" \
     --data-urlencode "disable_web_page_preview=true" \
     --data-urlencode "parse_mode=markdown" > /dev/null
