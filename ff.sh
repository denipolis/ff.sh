#!/bin/bash

WHITE='\033[1;37m'
RED='\033[1;31m'
ORANGE='\033[0;33m'

if [[ $# -eq 0 ]]; then
    printf "${WHITE}ff: <inputVideo> <timeStart HH:MM:SS> <timeEnd HH:MM:SS> <audio all|mic|game>\n"
    exit 1
fi

if [[ ! -f $1 ]]; then
    printf "${WHITE}ff: ${ORANGE}<inputVideo> ${WHITE}<timeStart HH:MM:SS> <timeEnd HH:MM:SS> <audio all|mic|game> - ${RED}file not found!\n"
    exit 1
fi

if ! [[ $2 =~ ^(((([0-1][0-9])|(2[0-3])):?[0-5][0-9]:?[0-5][0-9]+$)) ]]; then
    printf "${WHITE}ff: <inputVideo> ${ORANGE}<timeStart HH:MM:SS> ${WHITE}<timeEnd HH:MM:SS> <audio all|mic|game> - ${RED}time format is not right!\n"
     exit 1
fi

if ! [[ $3 =~ ^(((([0-1][0-9])|(2[0-3])):?[0-5][0-9]:?[0-5][0-9]+$)) ]]; then
    printf "${WHITE}ff: <inputVideo> <timeStart HH:MM:SS> ${ORANGE}<timeEnd HH:MM:SS> ${WHITE}<audio all|mic|game> - ${RED}time format is not right!\n"
     exit 1
fi

if [[ $4 != 'all' && $4 != 'mic' && $4 != 'game' ]]; then
    printf "${WHITE}ff: <inputVideo> <timeStart HH:MM:SS> <timeEnd HH:MM:SS> ${ORANGE}<audio all|mic|game> ${WHITE}- ${RED}select one of available options!\n"
    exit 1
fi

if [[ $4 = 'all' ]]; then
    ffmpeg -y -i $1 -ss $2 -to $3 -c:v copy -c:a aac -b:a 192k -ac 2 -filter_complex amerge=inputs=2 output.mp4
fi

if [[ $4 = 'mic' ]]; then
    ffmpeg -y -i 1.mp4 -ss 00:00:00 -to 00:00:05 -c:v copy -c:a aac -b:a 192k -map 0 -map -0:a:0 output.mp4
fi

if [[ $4 = 'game' ]]; then
    ffmpeg -y -i 1.mp4 -ss 00:00:00 -to 00:00:05 -c:v copy -c:a aac -b:a 192k -map 0 -map -0:a:1 output.mp4
fi