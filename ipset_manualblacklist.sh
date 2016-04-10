#! /bin/bash

# /usr/local/sbin/block

# Notes: Call this from crontab. Feed updated every 15 minutes.
# netmask=24: dshield's list is all class C networks
# hashsize=64: default is 1024 but 64 is more than needed here

ipset_name="blacklist"
target="/root/manualblacklist.txt"
ipset_params="hash:ip"


# Create list if not exists
ipset create -exist ${ipset_name} ${ipset_params}

for i in $( cat ${target} ) ; do ipset add ${ipset_name} $i ; done

# log the file modification time for use in minimizing lag in cron schedule
logger -p cron.notice "IPSet: ${ipset_name} updated (as of ${date})."
