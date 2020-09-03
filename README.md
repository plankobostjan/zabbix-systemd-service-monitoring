systemd Service Monitoring template for Zabbix
===========================================

NOTE
--------
This repo was originally forked from [here](https://github.com/MogiePete/zabbix-systemd-service-monitoring).
I also maintain this repo on [github](https://github.com/plankobostjan/zabbix-systemd-service-monitoring).

FEATURES
--------
* Discovery of systemd Services
  * Provides option of blacklisting or whitelisting services
* Provides alerting when a service stops or restarts

REQUIREMENTS
------------
* RHEL/CentOS/Oracle EL 7+
* Ubuntu 16.04+
* Zabbix 4.0+

INSTALLATION
------------
* Server
  * Import template from __systemd-services-zabbix-template.xml__
  * Link template to host
* Agent
  * Place the following file inside /usr/local/bin/:
    * zbx\_service\_restart\_check.sh
    * zbx\_service\_discovery.sh
  * Set executable permissions on both scripts
  * If running SELinux run restorecon on the two scripts in /usr/local/bin e.g. __restorecon -v /usr/local/bin/zbx*.sh__
  * Copy __userparameter\_systemd\_services.conf__ to __/etc/zabbix/zabbix\_agentd.d/userparameter\_systemd\_services.conf__
  * Restart zabbix_agent
* SELinux
  * For system running SELinux you will need to create a custom policy module
  * Please follow the directions above to install the template on the server and copy the files to the agent and then allow the agent to attempt discovery. (This can be sped up by changing the discovery update interval to 5m from 24H)
  * Once this has completed run the following commands to create a custom SELinux Policy Module
  * __grep zabbix\_agent\_t /var/log/audit/audit.log | grep denied | audit2allow -M zabbix_agent__
  * __semodule -i zabbix_agent.pp__
  * If you add additional services you will need to repeat this process. Sorry

Testing
-------
To test that everything works use `zabbix_agentd -t` to query the statistics :

```bash
# Discover systemd services
zabbix_agentd -t "systemd.service.discovery"
zabbix_agentd -t "systemd.service.status[sshd]"
zabbix_agentd -t "systemd.service.restart[sshd]"
```
