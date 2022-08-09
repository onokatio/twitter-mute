#!/bin/bash

source lib.sh

echo -n "Getting muted.json..."
if [ -f "muted.json" ];then
    echo "already exists. Skipping."
else
    twurl_cursor --username "onokatio_" "/1.1/mutes/users/list.json?skip_status=true" > muted.json
    echo "finish"
fi