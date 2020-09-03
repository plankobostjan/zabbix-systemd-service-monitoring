#!/bin/bash

service_list=$(systemctl list-unit-files | grep -E '\.service\s+(generated|enabled)' | awk -F'.service ' '{print $1}')

if [ $# -eq 0 ]
then
	echo -n '{"data":[';for s in ${service_list}; do echo -n "{\"{#SERVICE}\": \"$s\"},";done | sed -e 's:\},$:\}:';echo -n ']}'
elif [ $1 = "critical" ]
then
	echo -n '{"data":[';for s in ${service_list}; do echo -n "{\"{#SERVICE.CRITICAL}\": \"$s\"},";done | sed -e 's:\},$:\}:';echo -n ']}'
fi
