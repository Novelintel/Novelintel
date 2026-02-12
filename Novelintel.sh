#!/bin/bash

if ! command -v apt-get >/dev/null 2>&1; then
    echo "This script only supports Debian-based systems."
    exit 1
fi

if command -v xterm >/dev/null 2>&1; then
    echo "[+] xterm installed"
else
    echo "[-] xterm not installed (installing)"
    sudo apt-get update -qq >/dev/null 2>&1
    sudo apt-get install -y -qq xterm >/dev/null 2>&1

    if command -v xterm >/dev/null 2>&1; then
        echo "[+] xterm installed successfully"
    else
        echo "[!] Failed to install xterm"
        exit 1
    fi
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BASE_DIR="$(dirname "$(realpath "$0")")"
DATA_DIR="$BASE_DIR/Data"
MANUALS_DIR="$BASE_DIR/Manuals"
OSINTSCRAPER_DIR="$BASE_DIR/OSINTScraper"
PERSONAL_DIR="$DATA_DIR/Personal"

for folder in "$DATA_DIR" "$OSINTSCRAPER_DIR" "$MANUALS_DIR" "$PERSONAL_DIR"; do
  [ -d "$folder" ] || mkdir -p "$folder"
done

echo "Select a theme:"
echo "[1] Default"
echo "[2] Light"
echo "[3] Blue"
echo "[4] Green"
echo "[5] Red"
echo "[6] Purple"
echo "[7] Orange"
echo "[8] Teal"
echo "[9] Pink"
echo
read -p "> " theme_choice

case "$theme_choice" in
  1) BG_COLOR="#303130"; FG_COLOR="#ffffff" ;;
  2) BG_COLOR="#f0f0f0"; FG_COLOR="#000000" ;;
  3) BG_COLOR="#002b36"; FG_COLOR="#93a1a1" ;;
  4) BG_COLOR="#1b2b1b"; FG_COLOR="#d0ffd0" ;;
  5) BG_COLOR="#3a0d0d"; FG_COLOR="#ffcccc" ;;
  6) BG_COLOR="#2b1b3a"; FG_COLOR="#e0ccff" ;;
  7) BG_COLOR="#402a1b"; FG_COLOR="#ffd9b3" ;;
  8) BG_COLOR="#1b3a3a"; FG_COLOR="#b3ffff" ;;
  9) BG_COLOR="#3a1b2b"; FG_COLOR="#ffb3d9" ;;
  *) BG_COLOR="#303130"; FG_COLOR="#ffffff" ;;
esac

xterm -bg "$BG_COLOR" -fg "$FG_COLOR" \
      -fa "DejaVu Sans Mono" -fs 12 \
      -geometry 70x35 \
      +sb -b 8 \
      -hold -e bash --noprofile --norc -c '
SCRIPT_DIR="'"$SCRIPT_DIR"'"
BG_COLOR="'"$BG_COLOR"'"
FG_COLOR="'"$FG_COLOR"'"

type_text() {
  local text="$1"
  for ((i=0; i<${#text}; i++)); do
      printf "%c" "${text:i:1}"
      sleep 0.001
  done
  printf "\n"
}

B1="         _   ______ _    __________    _____   ________________ "
B2="        / | / / __ \ |  / / ____/ /   /  _/ | / /_  __/ ____/ / " 
B3="       /  |/ / / / / | / / __/ / /    / //  |/ / / / / __/ / /  "
B4="      / /|  / /_/ /| |/ / /___/ /____/ // /|  / / / / /___/ /___ "
B5="     /_/ |_/\____/ |___/_____/_____/___/_/ |_/ /_/ /_____/_____/   "                                                  
B6=""
B7="        Novelintel Ver 1.0 made by Novelintel Investigations "
B8="   Novelintel makes analyzing and harvesting information easier. "

draw_banner() {
  type_text "$B1"
  type_text "$B2"
  type_text "$B3"
  type_text "$B4"
  type_text "$B5"
  echo      "$B6"
  type_text "$B7"
  type_text "$B8"
  echo
}

main_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] HOST AND CREATE"
    echo "[2] OPEN DATA FOLDER"
    echo "[3] LAUNCH MAP VIEWER"
    echo "[4] OPEN SOURCE INTELLIGENCE"
    echo "[5] INSTALL ALL REQUIREMENTS"
    echo "[6] IP LOOKUP"
    echo "[7] ADD TARGET"
    echo "[8] PASSWORD ATTACKS"
    echo "[9] EXPLOITATION"
    echo "[10] NETWORK UTILITIES"
    echo "[11] PROTOCOLS AND REMOTE ACCESS"
    echo "[12] MAN IN THE MIDDLE"
    echo "[13] WIRELESS ATTACKS"
    echo "[14] DIGITAL FORENSICS"
    echo "[15] PACKET SNIFFERS"
    echo "[16] INSTALL GITHUB TOOLS"
    echo "[17] SYSTEM HEALTH & MONITORING"
    echo
    read -p "> " choice

    case "$choice" in
      1)
        host_create_menu
        ;;
      2)
        xdg-open "$SCRIPT_DIR/Data" >/dev/null 2>&1 &
        ;;
      3)
        echo
        echo "Enter location (address, coordinates, etc):"
        read -p "> " map_query
        map_query_encoded=$(echo "$map_query" | sed "s/ /+/g")
        xdg-open "https://www.google.com/maps/search/?api=1&query=$map_query_encoded" >/dev/null 2>&1 &
        ;;
      4)
        osint_menu
        ;;
      5)
        install_requirements_menu
        ;;
      6)
        ip_lookup_menu
        ;;
      7)
        add_target_menu
        ;;
      8)
       password_menu
       ;;
       9)
        exploitation_menu
        ;;
        10)
        network_menu
        ;;
        11)
        protocol_menu
        ;;
        12)
        mitm_menu
        ;;
        13)
        wireless_menu
        ;;
        14)
        forensics_menu
        ;;
        15)
        sniffer_menu
        ;;
        16)
        github_menu
        ;;
        17)
        system_health_menu
        ;;
      clear)
        continue
        ;;
      *)
        continue
        ;;
    esac
  done
}

system_health_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] CPU & LOAD OVERVIEW"
    echo "[2] MEMORY USAGE"
    echo "[3] DISK & FILESYSTEM REPORT"
    echo "[4] NETWORK STATUS"
    echo "[5] RUNNING SERVICES"
    echo "[6] SYSTEM LOGS"
    echo "[7] HARDWARE SENSORS (if supported)"
    echo "[8] RETURN"
    echo
    read -p "> " e

    case "$e" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "uptime; top -b -n1 | head -n 15; read -p \"Press enter to exit...\" " \
          >/dev/null 2>&1 &
        ;;

      2)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "free -h; vmstat -s; read -p \"Press enter to exit...\" " \
          >/dev/null 2>&1 &
        ;;

      3)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "df -h; lsblk; read -p \"Press enter to exit...\" " \
          >/dev/null 2>&1 &
        ;;

      4)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "ip a; ss -tulnp; read -p \"Press enter to exit...\" " \
          >/dev/null 2>&1 &
        ;;

      5)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "systemctl --type=service --state=running; read -p \"Press enter to exit...\" " \
          >/dev/null 2>&1 &
        ;;

      6)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "journalctl -f" \
          >/dev/null 2>&1 &
        ;;

      7)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "sensors || echo Sensors not supported; read -p \"Press enter to exit...\" " \
          >/dev/null 2>&1 &
        ;;

      8)
        break
        ;;
    esac
  done
}

github_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] ROUTERSPLOIT"
    echo "[2] WIFIPUMPKIN3"
    echo "[3] AIRGEDDON"
    echo "[4] FLUXION"
    echo "[5] WIFITE2"
    echo "[6] THEHARVESTER"
    echo "[7] GHOSTTRACK"
    echo "[8] BLACKBIRD"
    echo "[9] MRHOLMES"
    echo "[10] CUBIC"
    echo "[11] HOLEHE"
    echo "[12] GHUNT"
    echo "[13] MAILCAT"
    echo "[14] MALTEGO"
    echo "[15] MAIGRET"
    echo "[16] NEXFIL"
    echo "[17] RETURN"
    echo
    read -p "> " e

    case "$e" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://github.com/threat9/routersploit && cd routersploit; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/ROUTERSPLOIT.txt >/dev/null 2>&1 &
         ;;

        2)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://github.com/P0cL4bs/wifipumpkin3.git && cd wifipumpkin3; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/WIFIPUMPKIN3.txt >/dev/null 2>&1 &
         ;;

        
        3)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git && cd airgeddon; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/AIRGEDDON.txt >/dev/null 2>&1 &
         ;;
        
        4)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://www.github.com/FluxionNetwork/fluxion.git && cd fluxion; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/FLUXION.txt >/dev/null 2>&1 &
         ;;
        
        5)
          xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://github.com/derv82/wifite2.git && cd wifite2; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/WIFITE2.txt >/dev/null 2>&1 &
         ;;
        
        6)
          xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://github.com/laramies/theHarvester && cd theHarvester; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/THEHARVESTER.txt >/dev/null 2>&1 &
         ;;
        
        7)     
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://github.com/HunxByts/GhostTrack.git && cd GhostTrack; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/GHOSTTRACK.txt >/dev/null 2>&1 &
         ;;
        
        8)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://github.com/p1ngul1n0/blackbird && cd blackbird; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/BLACKBIRD.txt >/dev/null 2>&1 &
         ;;
        
        9)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://github.com/Lucksi/Mr.Holmes && cd Mr.Holmes; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/MRHOLMES.txt >/dev/null 2>&1 &
         ;;
        
        10)
          xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "mkdir cubic && cd cubic; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/CUBIC.txt >/dev/null 2>&1 &
         ;;
        
           11)       
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://github.com/megadose/holehe.git && cd holehe; exec bash" \
          >/dev/null 2>&1 &

         xdg-open Manuals/HOLEHE.txt >/dev/null 2>&1 &
         ;;
        
        12)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "mkdir ghunt && cd ghunt; exec bash" \
          >/dev/null 2>&1 &
          
         xdg-open Manuals/GHUNT.txt >/dev/null 2>&1 &
         ;;
        
        13)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "mkdir mailcat && cd mailcat; exec bash" \
          >/dev/null 2>&1 &
          
         xdg-open Manuals/MAILCAT.txt >/dev/null 2>&1 &
         ;;
        
        14)
        xdg-open "https://www.maltego.com/downloads/" >/dev/null 2>&1 &
        
        xdg-open Manuals/MALTEGO.txt >/dev/null 2>&1 &
         ;;
         
         15)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "git clone https://github.com/soxoj/maigret && cd maigret; exec bash" \
          >/dev/null 2>&1 &
          
         xdg-open Manuals/MAIGRET.txt >/dev/null 2>&1 &
         ;;
         
         16)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "mkdir nexfil && cd nexfil; exec bash" \
          >/dev/null 2>&1 &
         
        xdg-open Manuals/NEXFIL.txt >/dev/null 2>&1 &
         ;;
        
       17)
        break
        ;;
    esac
  done
}

sniffer_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] WIRESHARK"
    echo "[2] TSHARK"
    echo "[3] TCPDUMP"
    echo "[4] RETURN"
    echo
    read -p "> " e

    case "$e" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "wireshark; exec bash" \
          >/dev/null 2>&1 &
        ;;
        2)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "sudo tshark; exec bash" \
          >/dev/null 2>&1 &
        ;;
        3)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "tcpdump -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

       4)
        break
        ;;
    esac
  done
}

forensics_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] EXIFTOOL"
    echo "[2] OPENSSL"
    echo "[3] BASE64"
    echo "[4] STRINGS"
    echo "[5] BINWALK"
    echo "[6] MEDIAINFO"
    echo "[7] PDFINFO"
    echo "[8] PDFIMAGES"
    echo "[9] SONIC VISUALIZER"
    echo "[10] RETURN"
    echo
    read -p "> " e

    case "$e" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "exiftool -h; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
        2)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "openssl -h; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
        3)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "base64 --help; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
        4)
            xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "strings -h; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
        5)
          xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "binwalk -h; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
        6)
          xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "mediainfo -h; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
        7)
          xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "pdfinfo -h; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
        8)
          xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "pdfimages -h; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
        9)
          sonic-visualiser >/dev/null 2>&1 &
        ;;

       10)
        break
        ;;
    esac
  done
}

wireless_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] AIRCRACK"
    echo "[2] AIRGEDDON"
    echo "[3] FLUXION"
    echo "[4] WIFITE2"
    echo "[5] WIFIPUMPKIN3"
    echo "[6] RETURN"
    echo
    read -p "> " e

    case "$e" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "aircrack-ng -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      2)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd airgeddon && sudo bash airgeddon.sh; exec bash" \
          >/dev/null 2>&1 &
        ;;

      3)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd fluxion && sudo ./fluxion.sh; exec bash" \
          >/dev/null 2>&1 &
        ;;
        4)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd wifite2 && sudo ./Wifite.py; exec bash" \
          >/dev/null 2>&1 &
        ;;
        5)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd wifipumpkin3 && sudo wifipumpkin3" \
          >/dev/null 2>&1 &
        ;;

       6)
        break
        ;;
    esac
  done
}

mitm_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] BETTERCAP"
    echo "[2] DSNIFF"
    echo "[3] YERSINIA"
    echo "[4] RETURN"
    echo
    read -p "> " e

    case "$e" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "bettercap -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      2)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "dsniff -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      3)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "sudo yersinia -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

       4)
        break
        ;;
    esac
  done
}

protocol_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] SSH"
    echo "[2] REMMINA"
    echo "[3] VNCVIEWER"
    echo "[4] NETCAT"
    echo "[5] FTP"
    echo "[6] TELNET"
    echo "[7] SMBCLIENT"
    echo "[8] XFREERDP"
    echo "[9] RETURN"
    echo
    read -p "> " n

    case "$n" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "nmap; exec bash" \
          >/dev/null 2>&1 &
        ;;

      2)
        remmina >/dev/null 2>&1 &
        ;;

      3)
        vncviewer >/dev/null 2>&1 &
        ;;

      4)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "nc; exec bash" \
          >/dev/null 2>&1 &
        ;;

      5)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "ftp; exec bash" \
          >/dev/null 2>&1 &
        ;;

      6)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "telnet; exec bash" \
          >/dev/null 2>&1 &
        ;;

      7)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "smbclient; exec bash" \
          >/dev/null 2>&1 &
        ;;
      8)
          xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "xfreerdp -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      9)
        break
        ;;
    esac
  done
}

network_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] NMAP"
    echo "[2] NCRACK"
    echo "[3] HPING3"
    echo "[4] TRACEROUTE"
    echo "[5] SSHSCAN"
    echo "[6] NETDISCOVER"
    echo "[7] ARP-SCAN"
    echo "[8] ARPING"
    echo "[9] RETURN"
    echo
    read -p "> " n

    case "$n" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "nmap -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      2)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "ncrack -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      3)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "hping3 -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      4)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "traceroute --help; exec bash" \
          >/dev/null 2>&1 &
        ;;

      5)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "scanssh -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      6)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "netdiscover -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      7)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "arp-scan -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      8)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "arping -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      9)
        break
        ;;
    esac
  done
}

exploitation_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] MSFVENOM"
    echo "[2] MSFCONSOLE"
    echo "[3] SEARCHSPLOIT"
    echo "[4] ROUTERSPLOIT"
    echo "[5] RETURN"
    echo
    read -p "> " e

    case "$e" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "msfvenom -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      2)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "msfconsole -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      3)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "searchsploit -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      4)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd routersploit && python3 rsf.py; exec bash" \
          >/dev/null 2>&1 &
        ;;

      5)
        break
        ;;
    esac
  done
}

password_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] HYDRA"
    echo "[2] JOHN THE RIPPER"
    echo "[3] MEDUSA"
    echo "[4] HASHCAT"
    echo "[5] RETURN"
    echo
    read -p "> " p

    case "$p" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "hydra -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      2)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "john; exec bash" \
          >/dev/null 2>&1 &
        ;;

      3)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "medusa -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      4)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "hashcat -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      5)
        break
        ;;
    esac
  done
}

ip_lookup_menu() {
  echo
  echo "Enter an IP address or domain:"
  read -p "> " target

  echo
  echo "=============================="
  echo "WHOIS RESULT"
  echo "=============================="
  whois "$target" 2>/dev/null

  echo
  echo "=============================="
  echo "DIG RESULT"
  echo "=============================="
  dig "$target" ANY +short 2>/dev/null

  echo
  echo "=============================="
  echo "CURL RESULT (HTTP HEADERS)"
  echo "=============================="
  curl -I --max-time 5 "$target" 2>/dev/null

  echo
  echo "=============================="
  echo "GEOIPLOOKUP RESULT"
  echo "=============================="
  geoiplookup "$target" 2>/dev/null

  echo
  echo "=============================="
  echo "NSLOOKUP RESULT"
  echo "=============================="
  nslookup "$target" 2>/dev/null

  echo
  echo "Lookup complete."
  read -p "Press Enter to return..."
}

install_requirements_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] AUTOMATIC"
    echo "[2] MANUAL (Recommended)"
    echo "[3] RETURN"
    echo
    read -p "> " im

    case "$im" in
      1)
        sudo apt update -y
        sudo apt install -y php dnsutils ssh telnet ftp whois wget ffmpeg traceroute geoip-bin libimage-exiftool-perl hydra john medusa hashcat nmap ncrack netcat-openbsd masscan hping3 netdiscover arp-scan arping remmina smbclient scanssh mysql-client postgresql-client mosquitto-clients bettercap tcpdump aircrack-ng mdk4 dnsmasq wireshark tigervnc-viewer dsniff php-cgi openvpn macchanger yersinia tshark freerdp2-x11 binwalk binutils poppler-utils sonic-visualiser
        sudo snap install spiderfoot
        echo
        echo "Automatic installation complete."
        read -p "Press Enter to continue..."
        ;;

      2)
        packages=("php" "dnsutils" "ssh" "telnet" "ftp" "whois" "wget" "ffmpeg" "traceroute" "geoip-bin" "libimage-exiftool-perl" "hydra" "john" "medusa" "hashcat" "nmap" "ncrack" "netcat-openbsd" "masscan" "hping3" "netdiscover" "arp-scan" "arping" "remmina" "smbclient" "scanssh" "mysql-client" "postgresql-client" "mosquitto-clients" "bettercap" "tcpdump" "aircrack-ng" "mdk4" "dnsmasq" "wireshark" "tigervnc-viewer" "dsniff" "php-cgi" "openvpn" "macchanger" "yersinia" "tshark" "freerdp2-x11" "binwalk" "binutils" "poppler-utils" "sonic-visualiser")

        for pkg in "${packages[@]}"; do
          if command -v "$pkg" >/dev/null 2>&1; then
            echo "[+] $pkg installed"
          else
            echo
            read -p "Do you want to install $pkg? (y/n): " ans
            if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
              sudo apt install -y "$pkg"
            fi
          fi
        done

        if snap list | grep -q spiderfoot; then
          echo "[+] spiderfoot installed"
        else
          echo
          read -p "Do you want to install spiderfoot? (y/n): " ans
          if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            sudo snap install spiderfoot
          fi
        fi
        
        if snap list | grep -q metasploit-framework; then
          echo "[+] metasploit installed"
        else
          echo
          read -p "Do you want to install metasploit? (y/n): " ans
          if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            sudo snap install metasploit-framework
          fi
        fi

        if snap list | grep -q searchsploit; then
          echo "[+] searchsploit installed"
        else
          echo
          read -p "Do you want to install searchsploit? (y/n): " ans
          if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            sudo snap install searchsploit
          fi
        fi

        echo
        echo "Manual installation complete."
        read -p "Press Enter to continue..."
        ;;

      3)
        break
        ;;

      clear)
        continue
        ;;

      *)
        ;;
    esac
  done
}

osint_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] SPIDERFOOT"
    echo "[2] THEHARVESTER"
    echo "[3] GHOSTTRACK"
    echo "[4] BLACKBIRD"
    echo "[5] MRHOLMES"
    echo "[6] GOOGLE DORKING"
    echo "[7] OATHNET"
    echo "[8] OSINT INDUSTRIES"
    echo "[9] OSINT FRAMEWORK"
    echo "[10] TRUE CALLER (Telegram bot)"
    echo "[11] MAIGRETBOT (Telegram bot)"
    echo "[12] LEAKBOT (Telegram bot)"
    echo "[13] PENTESTER"
    echo "[14] HOLEHE"
    echo "[15] GHUNT"
    echo "[16] MAILCAT"
    echo "[17] MALTEGO"
    echo "[18] MAIGRET"
    echo "[19] NEXFIL"
    echo "[20] RETURN"
    echo
    read -p "> " o

    case "$o" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "spiderfoot -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      2)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd TheHarvester && uv run theHarvester -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      3)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd GhostTrack && python3 GhostTR.py; exec bash" \
          >/dev/null 2>&1 &
        ;;

      4)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd blackbird && python3 blackbird.py -h; exec bash" \
          >/dev/null 2>&1 &
        ;;

      5)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd Mr.Holmes && python3 MrHolmes.py; exec bash" \
          >/dev/null 2>&1 &
        ;;

      6)
        echo
        echo "Enter a full Google Dork query, you can also combine multiple queries."
        echo
        echo "  filetype:pdf OR filetype:docx etc. \"Name, Email etc.\"" 
        echo "  intext:Username etc. site:example.com"
        echo "  site:example.com \"Name, Email etc.\""
        echo "  cache:example.com \"Name, Email etc.\""
        echo "  related:example.com \"Name, Email etc.\""
        echo "  link:example.com \"Name, Email etc.\""
        echo "  intitle:Name, Email etc."
        echo "  allintitle:Name, Email etc."
        echo "  inurl:Name, Email etc."
        echo "  allinurl:Name, Email etc."
        echo "  location:City, State"
        echo "  after:YYYY-MM-DD"
        echo "  before:YYYY-MM-DD"
        echo "  define:Name"
        echo "  More on https://www.exploit-db.com/google-hacking-database"
        echo
        read -p "> " dork
        dork_encoded=$(echo "$dork" | sed "s/ /+/g")
        xdg-open "https://www.google.com/search?q=$dork_encoded" >/dev/null 2>&1 &
        ;;

      7)  xdg-open "https://oathnet.org/" >/dev/null 2>&1 & ;;
      8)  xdg-open "https://www.osint.industries/" >/dev/null 2>&1 & ;;
      9)  xdg-open "https://www.osintframework.com/" >/dev/null 2>&1 & ;;
      10) xdg-open "https://t.me/true_caller" >/dev/null 2>&1 & ;;
      11) xdg-open "https://t.me/osint_maigret_bot" >/dev/null 2>&1 & ;;
      12) xdg-open "https://t.me/LeakLookup_bot" >/dev/null 2>&1 & ;;
      13) xdg-open "https://pentester.com/" >/dev/null 2>&1 & ;;

      14)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd holehe && holehe; exec bash" \
          >/dev/null 2>&1 &
        ;;

      15)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "ghunt; exec bash" \
          >/dev/null 2>&1 &
        ;;

      16)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd mailcat && ./mailcat.py; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
        17)
          maltego >/dev/null 2>&1 &
        ;;
        
        18)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd maigret && maigret --help; exec bash" \
          >/dev/null 2>&1 &
        ;;
        19)
           xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "nexfil --help; exec bash" \
          >/dev/null 2>&1 &
        ;;
        
      20)
        break
        ;;
    esac
  done
}


add_target_menu() {
  echo
  echo "Target in mind?"
  read -p "> " target

  newfolder="$SCRIPT_DIR/Data/Personal/$target"

  mkdir -p "$newfolder"

  touch "$newfolder/$target.txt"

  echo
  echo "Created: $newfolder"
  echo "Created: $newfolder/$target.txt"
  echo
  read -p "Press Enter to return..."
}

host_create_menu() {
  while true; do
    clear
    draw_banner
    echo "[1] HOST OSINTSCRAPER"
    echo "[2] HOST MINECRAFT SERVER"
    echo "[3] CREATE ISO (cubic if installed)"
    echo "[4] GOOGLE FORM"
    echo "[5] RETURN"
    echo
    read -p "> " choice2

    case "$choice2" in

      1)
        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd \"$SCRIPT_DIR/OSINTScraper\" && bash OSINTScraper.sh; exec bash" \
          >/dev/null 2>&1 &

        xterm \
          -bg "$BG_COLOR" -fg "$FG_COLOR" \
          -fa "DejaVu Sans Mono" -fs 12 \
          -geometry 90x35 \
          -e bash -c "cd \"$SCRIPT_DIR/OSINTScraper\" && bash CaptchaControl.sh; exec bash" \
          >/dev/null 2>&1 &
        ;;

      2)
        xdg-open "https://aternos.org/" >/dev/null 2>&1 &
        ;;

      3)
        cubic
        ;;

      4)
        xdg-open "https://docs.google.com/forms" >/dev/null 2>&1 &
        ;;

      5)
        break
        ;;
    esac
  done
}

main_menu
'

