#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Variables

shells="Reverse Shell:Bind Shell:MSFVenom Shell"
fileName=$(cat config.conf | grep -oP "fileName:\K.*")
typeOfShell=$(cat config.conf | grep -oP "shell:\K.*")

clear
echo -ne ${blueColour}
echo -e '\n _______                                                                      ______   __                  __  __ \n|       \                                                                    /      \ |  \                |  \|  \\\n| $$$$$$$\  ______  __     __   ______    ______    _______   ______        |  $$$$$$\| $$____    ______  | $$| $$\n| $$__| $$ /      \|  \   /  \ /      \  /      \  /       \ /      \       | $$___\$$| $$    \  /      \ | $$| $$\n| $$    $$|  $$$$$$\\\$$\ /  $$|  $$$$$$\|  $$$$$$\|  $$$$$$$|  $$$$$$\       \$$    \ | $$$$$$$\|  $$$$$$\| $$| $$\n| $$$$$$$\| $$    $$ \$$\  $$ | $$    $$| $$   \$$ \$$    \ | $$    $$       _\$$$$$$\| $$  | $$| $$    $$| $$| $$\n| $$  | $$| $$$$$$$$  \$$ $$  | $$$$$$$$| $$       _\$$$$$$\| $$$$$$$$      |  \__| $$| $$  | $$| $$$$$$$$| $$| $$\n| $$  | $$ \$$     \   \$$$    \$$     \| $$      |       $$ \$$     \       \$$    $$| $$  | $$ \$$     \| $$| $$\n \$$   \$$  \$$$$$$$    \$      \$$$$$$$ \$$       \$$$$$$$   \$$$$$$$        \$$$$$$  \$$   \$$  \$$$$$$$ \$$ \$$'
echo -ne ${endColour}
echo -e "\n\n${redColour}v1.0 by BlackStargal${endColour}\n\n\n"

while true; do
echo -e "${blueColour}[1] Search reverse shell\n[2] List all payloads\n[3] Check files\n[x] Exit\n\n${endcolour}"
echo -ne "${purpleColour}Reverse Shell -> ${endColour}"
read -r option
clear
if [ "$option" == "x" ]; then echo -e "\n${redColour}Exiting...${endColour}\n" && exit 0; fi
if [ "$option" == "1" ]; then 
  echo -e "\nSelect the type of shell:\n\n${blueColour}[1] Reverse Shell\n[2] Bind Shell\n[3] MSFVenom Shell\n\n${endcolour}"
  echo -ne "${purpleColour}Reverse Shell -> ${endColour}"
  read -r shellType
  if [ $shellType -eq 1 ]; then shellFile="reverseShellCommands"; else if [ $shellType -eq 2 ]; then shellFile="bindShellCommands"; else if [ $shellType -eq 3 ]; then shellFile="msfVenomShellCommands"; else if [ $shellType -gt 3 ]; then echo -e "\n${redColour}[!]${endColour} Invalid option\n" && exit 1;fi;fi;fi;fi
  clear
  echo -ne "\nSearch ${purpleColour}$(echo -n $shells | awk -v var="$shellType" $'{print $var}' FS=':')${endColour} -> "
  read -r search
  clear
  echo -e "\nSearching for ${purpleColour}$search${endColour}...\n"
  sleep 1.2
  if [ $(cat $shellFile | grep -oP "\"name\": \K\".*?\"" | tr -d '"' | grep -i $search | wc -l) -eq 0 ]; then
    echo -e "\n${redColour}[!]${endColour} No results found for $search\n"
    exit 0
  else
    response=$(cat $shellFile | grep -oP "\"name\": \K\".*?\"" | tr -d '"' | grep -i "$search" | tr '\n' ':')
    numberResults=$(echo -n $response | tr ':' '\n' | wc -l)
    clear
    echo -e "\n${greenColour}[+]${endColour} $numberResults Results found:\n"
    echo -e ${purpleColour}
    echo $response | tr ':' '\n' | nl -w2 -s' -> '
    echo -e "${endColour}\n"
    echo -e "\nSelect the shell:\n"
    echo -ne "${purpleColour}Shell -> ${endColour}"
    read -r shell
    if [ $shell -gt $numberResults ]; then echo -e "\n${redColour}[!]${endColour} Invalid option\n" && exit 1; fi
    selectedShell=$(echo $response | awk -v var="$shell" $'{print $var}' FS=':')
    clear
    echo -e "\n${purpleColour}$selectedShell${endColour} selected:\n"
    echo -ne "${purpleColour}Local IP ->${endColour} "
    read -r ip
    echo -ne "${purpleColour}Local Port ->${endColour} "
    read -r port
    clear
    echo -e "\nIP -> ${purpleColour}$ip${endColour}\n\nPort -> ${purpleColour}$port${endColour}\n"
    echo -e "${purpleColour}Generating shell...${endColour}"
    sleep 1
    clear
    echo -ne "\n\n${greenColour}[+]${endColour} Shell:\n"
    if [ $(ls . | grep -oP "shells" | wc -l) -eq 0 ];then mkdir shells; fi
    cat $shellFile | grep "\"name\": \"$selectedShell\"" -A 1 | grep -oP "\"command\": \"\K.*" | sed 's/.\{2\}$//' | sed -e "s/{shell}/$typeOfShell/g" | sed -e "s/{ip}/$ip/g" | sed -e "s/{port}/$port/g" > shells/$fileName
    echo
    cat shells/$fileName
    echo -e "\nCreated file ${purpleColour}$fileName${endColour} in the shells directory\n"
    exit 0
  fi
fi
if [ "$option" == "2" ]; then
  echo -e "\nSelect the type of shell:\n\n${blueColour}[1] Reverse Shell\n[2] Bind Shell\n[3] MSFVenom Shell\n\n${endcolour}"
  echo -ne "${purpleColour}Reverse Shell -> ${endColour}"
  read -r shellType
  if [ $shellType -eq 1 ]; then shellFile="reverseShellCommands"; else if [ $shellType -eq 2 ]; then shellFile="bindShellCommands"; else if [ $shellType -eq 3 ]; then shellFile="msfVenomShellCommands"; else if [ $shellType -gt 3 ]; then echo -e "\n${redColour}[!]${endColour} Invalid option\n" && exit 1;fi;fi;fi;fi
  clear
  echo -e "\nListing all payloads for ${purpleColour}$(echo -n $shells | awk -v var="$shellType" $'{print $var}' FS=':')${endColour}\n"
  sleep 1.4
  echo -e "${purpleColour}$(cat $shellFile | grep -oP "\"name\": \K\".*?\"" | tr -d '"' | column)${endColour}"
  exit 0
fi
if [ $option -eq 3 ]; then
  echo -e "\nChecking files...\n"
  sleep 1
  clear
  if [ $(ls bindShellCommands config.conf msfVenomShellCommands reverseShellCommands | tr ' ' '\n' | wc -l) -eq 4 ]; then
    echo -e "\n${greenColour}[+]${endColour} All files found!\n"
  else
    echo -e "\n${redColour}[!]${endColour} Missing files!\n\nDownload the tool again from this repository: ${purpleColour}https://github.com/BlackStargal/reverseShells${endColour}\n"
  fi
  exit 0
fi
if [ "$option" != "x" ] || [ $option -gt 3 ]; then
  echo -e "\n${redColour}[!]${endColour} Invalid option\n"
  exit 1
fi
done
