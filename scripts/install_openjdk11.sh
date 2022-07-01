#!/bin/bash

## Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
# Clear the color after that
clear='\033[0m'

## Ensure Linux Distribution is Ubuntu 20.04  ##
if cat /etc/*release | grep ^NAME | grep -i ubuntu && \
   cat /etc/*release | grep ^VERSION_ID | grep 20.04 ; then
   echo -e "${yellow}=========================="
   echo -e "${yellow}Updating existing packages"
   echo -e "${yellow}==========================${clear}"
   
   ## Update exiting packages ##
   sudo apt update && sudo apt upgrade -y
   echo -e "${green}Done${clear}"

   ## Install OpenJDK 11 LTS - JRE ##
   echo -e "${yellow}==============================="
   echo -e "${yellow}Installing OpenJDK 11 LTS - JRE"
   echo -e "${yellow}===============================${clear}"
   sudo apt-get install openjdk-11-jre -y
   echo -e "${green}Done${clear}"

   ## Install OpenJDK 11 LTS – JDK ##
   echo -e "${yellow}==============================="
   echo -e "${yellow}Installing OpenJDK 11 LTS - JDK"
   echo -e "${yellow}===============================${clear}"
   sudo apt-get install openjdk-11-jdk -y
   echo -e "${green}Done${clear}"
   
   ## Verify Java Version ##
   java --version
   if [ $? -eq 0 ]; then
      echo -e "${green}Java Installed${clear}"
   else
      echo -e "${red}Java Not Installed"
   fi

else
   echo -e "${red}Linux Distribution doesn't match requirement${clear}"
fi