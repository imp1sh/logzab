# logzab
Zabbix log analyser for debian bases operating systems. It just finds string occurences in logfiles and count them based upon specific criteria.

## OS
Debian / Ubuntu. Might work on other compatible GNU/Linux OSes but only tested on Debian 8 and Ubuntu 14.04.

## What it does
This script collection analyses logfiles to gather statistical data from the specific services or applications, like:

- shorewall
- dovecot
- postfix
- /var/log/auth.log
- more to come

Later we will also deliver template files for zabbix.
It'll count for example how often packets were blocked in shorewall or failed ssh logins or fail2ban Ban / Unban actions

## Requirements
- logtail
