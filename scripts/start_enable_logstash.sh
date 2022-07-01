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

   ## Start and Enable Logstash ##
   echo -e "${yellow}=============================="
   echo -e "${yellow}Starting and Enabling logstash"
   echo -e "${yellow}==============================${clear}"
   sudo systemctl start logstash
   sudo systemctl enable logstash
   echo -e "${green}Done${clear}"
else
   echo -e "${red}Linux Distribution doesn't match requirement${clear}"
fi