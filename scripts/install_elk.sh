#!/bin/bash

## Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
# Clear the color after that
clear='\033[0m'

## Import the Elasticsearch public GPG key  ##
if cat /etc/*release | grep ^NAME | grep -i ubuntu && \
   cat /etc/*release | grep ^VERSION_ID | grep 20.04 ; then
   echo -e "${yellow}=========================================="
   echo -e "${yellow}Importing the Elasticsearch public GPG key"
   echo -e "${yellow}==========================================${clear}"
   
   ## Import GPG key ##
   curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

   ## Add the Elastic package source list to install Elasticsearch ##
   echo -e "${yellow}=================================="
   echo -e "${yellow}Adding Elastic package source list"
   echo -e "${yellow}==================================${clear}"
   echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
   echo -e "${green}Done${clear}"

   ## Update packages ##
   sudo apt update

   ## Install elasticsearch ##
   echo -e "${yellow}========================"
   echo -e "${yellow}Installing elasticsearch"
   echo -e "${yellow}========================${clear}"
   sudo apt install elasticsearch -y
   echo -e "${green}Done${clear}"

   ## Start and Enable elasticsearch ##
   echo -e "${yellow}==================================="
   echo -e "${yellow}Starting and Enabling elasticsearch"
   echo -e "${yellow}===================================${clear}"
   sudo systemctl start elasticsearch
   sudo systemctl enable elasticsearch
   echo -e "${green}Done${clear}"

   ## Install kibana ##
   echo -e "${yellow}========================"
   echo -e "${yellow}Installing kibana"
   echo -e "${yellow}========================${clear}"
   sudo apt install kibana -y
   echo -e "${green}Done${clear}"

   ## Start and Enable kibana ##
   echo -e "${yellow}==================================="
   echo -e "${yellow}Starting and Enabling kibana"
   echo -e "${yellow}===================================${clear}"
   sudo systemctl start kibana
   sudo systemctl enable kibana
   echo -e "${green}Done${clear}"
else
   echo -e "${red}Linux Distribution doesn't match requirement${clear}"
fi