#!/bin/bash

HTML_FILE="DeepSearch/Reminder.html"

banner() {
  clear
  local text="
         ______            __       __             ______            __             __
        / ____/___ _____  / /______/ /_  ____ _   / ____/___  ____  / /__________  / /
       / /   / __  / __ \/ __/ ___/ __ \/ __  /  / /   / __ \/ __ \/ __/ ___/ __ \/ / 
      / /___/ /_/ / /_/ / /_/ /__/ / / / /_/ /  / /___/ /_/ / / / / /_/ /  / /_/ / /  
      \____/\__,_/ .___/\__/\___/_/ /_/\__,_/   \____/\____/_/ /_/\__/_/   \____/_/   
                /_/                                                                       

    Captcha Control allows you to configure the redirect behavior in Reminder.html. 
    Based on whether the victim provides a valid or invalid Captcha, you can either grant
                 or deny them access to the DeepSearch engine.
                  Part of Novelintel by Novelintel Investigations  
"
  for ((i=0; i<${#text}; i++)); do
    printf "%c" "${text:i:1}"
    sleep 0.001
  done
  printf "\n"
}

while true; do
banner
echo "Choose an option:"
echo "1 - Set I Agree redirect to OSINTScraper.html (Valid Image)"
echo "2 - Set I Agree redirect to /Engine/OSINTScraper.html (Invalid Image)"
echo "q - Quit"
read -p "Enter choice (1, 2 or q): " choice

case $choice in
  1)
    sed -i "s|onclick=\"location.href='Engine/OSINTScraper.html'\"|onclick=\"location.href='OSINTScraper.html'\"|" "$HTML_FILE"
    echo "Updated I Agree redirect to OSINTScraper.html (Image was Valid)"
    ;;
  2)
    sed -i "s|onclick=\"location.href='OSINTScraper.html'\"|onclick=\"location.href='Engine/OSINTScraper.html'\"|" "$HTML_FILE"
    echo "Updated I Agree redirect to /Engine/OSINTScraper.html (Image was Invalid)"
    ;;
  q|Q)
   echo "Exiting Captcha Control."
   break
   ;;
  *)
    echo "Invalid choice. Please enter 1 or 2."
    ;;
esac

echo
  read -p "Press Enter to continue..." dummy
done

