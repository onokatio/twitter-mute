#!/bin/bash

source lib.sh

twurl --username "onokatio_" "/1.1/lists/ownerships.json?count=1000" | jq -r .lists[].id_str | \
while read line ;do
    echo -n "Getting list list_$line.json..."
    if [ -f "list_$line.json" ];then
        echo "already exists. Skipping."
        continue
    fi
    twurl --username "onokatio_" "/1.1/lists/members.json?count=5000&list_id=$line" | jq -r '.users[]' > list_$line.json
    echo "finish"
done

target_count=$(jq '[inputs] | sort_by(.statuses_count) | reverse' list_*.json | jq -r '.[] | select(.following == true) | .screen_name' | wc -l)
count=0
jq '[inputs] | sort_by(.statuses_count) | reverse' list_*.json | jq -r ' .[] | select(.following == true) | .screen_name' | \
while read line
do
    count=$((count+1))
    echo -n "Muting $line... $count/$target_count"
    if [ `cat muted.json | jq -r .users[].screen_name | grep -q "$line"` ];then
        echo "Already muted. Skipping."
        continue
    fi
    twurl_cursor --username "onokatio_" -d "screen_name=$line" "/1.1/mutes/users/create.json" >>log.txt
done