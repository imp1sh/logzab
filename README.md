# logzab
Zabbix log analyser for debian bases operating systems. It just finds string occurences in logfiles and count them based upon specific criteria.

## OS
Debian / Ubuntu. Might work on other compatible GNU/Linux OSes but only tested on Debian 8 and Ubuntu 14.04.

## What it does
This script collection analyses logfiles to gather statistical data from the specific services or applications, like:

- shorewall
- dovecot
- postfix
- fail2ban
- /var/log/auth.log
- more to come

Later we will also deliver template files for zabbix.
It'll count for example how often packets were blocked in shorewall or failed ssh logins or fail2ban Ban / Unban actions

## Requirements
- logtail
- pflogsumm for postfix analysis

## Installation
- cd opt
- git clone https://github.com/imp1sh/logzab.git
- cd logzab
- ln -s logzab_zabbix_include /etc/zabbix/zabbix_agentd.conf.d/
- restart zabbix agent

## Usage
- use logzab item like this for example: logzab[shorewalldropifin,eth0]
- logzab is the UserParameter, first parameter is the app, second parameter is optional and only needed when a selection is necessary, like with shorewalldropifin (i.e. the interface as selector)
- look in taillogit.bash for a list of available apps



