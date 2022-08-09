#!/bin/bash

function twurl_cursor(){
    next_cursor=-1
    while [ "$next_cursor" != "0" ];do
        result=$(twurl ${@}&cursor=$next_cursor)
        #echo "$result" | jq -c . >/dev/stderr
        next_cursor=$(echo $result | jq -r '.next_cursor_str')
        errors=$(echo $result | jq -c .errors)
        if [ "$errors" != "null" ];then
            continue
        fi
        echo "$result"
    done
}