#!/bin/bash

FILE_PATH=$3                                   # Aria2传递给脚本的文件路径。BT下载有多个文件时该值为文件夹内第一个文件，如/root/Download/a/b/1.mp4
RELATIVE_PATH=${FILE_PATH#${DOWNLOAD_PATH}/}   # 路径转换，去掉开头的下载路径。
TOP_PATH=${DOWNLOAD_PATH}/${RELATIVE_PATH%%/*} # 路径转换，BT下载文件夹时为顶层文件夹路径，普通单文件下载时与文件路径相同。

LIGHT_GREEN_FONT_PREFIX="\033[1;32m"
FONT_COLOR_SUFFIX="\033[0m"
INFO="[${LIGHT_GREEN_FONT_PREFIX}INFO${FONT_COLOR_SUFFIX}]"

echo -e "$(date +"%m/%d %H:%M:%S") ${INFO} Delete .aria2 file ..."

if [ $2 -eq 0 ]; then
    exit 0
elif [ -e "${filepath}.aria2" ]; then
    rm -vf "${filepath}.aria2"
elif [ -e "${topPath}.aria2" ]; then
    rm -vf "${topPath}.aria2"
fi
echo -e "$(date +"%m/%d %H:%M:%S") ${INFO} Delete .aria2 file finish"
echo "$(($(cat numUpload)+1))" > numUpload # Plus 1

if [[ $2 -eq 1 ]]; then # single file
	rclone -v --config="rclone.conf" copy "$3" "DRIVE:$RCLONE_DESTINATION" 2>&1	
elif [[ $2 -gt 1 ]]; then # multiple file
	rclone -v --config="rclone.conf" copy "$topPath" "DRIVE:$RCLONE_DESTINATION/${relativePath%%/*}"
fi

echo "$(($(cat numUpload)-1))" > numUpload # Minus 1
