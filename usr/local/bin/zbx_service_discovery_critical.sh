#!/bin/bash

service_list=$(systemctl list-unit-files | grep -E '\.service\s+(generated|enabled)' | awk -F'.service ' '{print $1}')

[[ -r /etc/zabbix/service_discovery_whitelist ]] && {
    service_list=$(echo "$service_list" | grep -E -f /etc/zabbix/service_discovery_whitelist_critical)
}

[[ -r /etc/zabbix/service_discovery_blacklist ]] && {
    service_list=$(echo "$service_list" | grep -Ev -f /etc/zabbix/service_discovery_blacklist_critical)
}

echo -n '{"data":[';for s in ${service_list}; do echo -n "{\"{#SERVICE.CRITICAL}\": \"$s\"},";done | sed -e 's:\},$:\}:';echo -n ']}'
