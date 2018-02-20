#!/bin/bash

# Original script from https://github.com/gregvw/amd_sdk/

# Location from which get nonce and file name from
URL="https://developer.amd.com/amd-accelerated-parallel-processing-app-sdk/"
URLDOWN="https://developer.amd.com/amd-license-agreement-appsdk/"

NONCE1_STRING='name="amd_developer_central_downloads_page_nonce"'
FILE_STRING='name="f"'
POSTID_STRING='name="post_id"'
NONCE2_STRING='name="amd_developer_central_nonce"'
USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0'

FORM=`wget -c -t 3 --waitretry=3 --user-agent="$USER_AGENT" -O - $URL | sed -n '/download-2/,/64-bit/p'`

# Get nonce from form
NONCE1=`echo $FORM | awk -F ${NONCE1_STRING} '{print $2}'`
NONCE1=`echo $NONCE1 | awk -F'"' '{print $2}'`

# get the postid
POSTID=`echo $FORM | awk -F ${POSTID_STRING} '{print $2}'`
POSTID=`echo $POSTID | awk -F'"' '{print $2}'`

# get file name
FILE=`echo $FORM | awk -F ${FILE_STRING} '{print $2}'`
FILE=`echo $FILE | awk -F'"' '{print $2}'`

FORM=`wget -c -t 3 --waitretry=3 --user-agent="$USER_AGENT" -O - $URLDOWN --post-data "amd_developer_central_downloads_page_nonce=${NONCE1}&f=${FILE}&post_id=${POSTID}"`

NONCE2=`echo $FORM | awk -F ${NONCE2_STRING} '{print $2}'`
NONCE2=`echo $NONCE2 | awk -F'"' '{print $2}'`

wget -c -t 3 --waitretry=3 --content-disposition --trust-server-names $URLDOWN --post-data "amd_developer_central_nonce=${NONCE2}&f=${FILE}" --user-agent="$USER_AGENT" -O AMD-SDK.tar.bz2;
