# logzab
Zabbix log analyser for Unix compatible operating systems. It just finds string occurences in logfiles and counts them based upon specific criteria. Those occurences are being used for convenience by getting nice graphs.


## OS
Tested on Debian / Ubuntu. Might work on other compatible GNU/Linux OSes.

## What it does
This script collection analyses logfiles to gather statistical data from the specific services or applications, like:

- shorewall
- dovecot
- postfix
- fail2ban
- /var/log/auth.log
- more to come

Later we will also deliver template files for zabbix. Template files for logzab apps that offer a second parameter are not there.
Logzab wil e.g. count how often packets were blocked in shorewall, failed ssh logins or fail2ban events.
Theoretically it is also some kind of a very flexible log analyser.

## Requirements
- logtail
- pflogsumm for postfix analysis

## Installation
- cd opt
- git clone https://github.com/imp1sh/logzab.git
- cd logzab
- ln -s logzab_zabbix_include /etc/zabbix/zabbix_agentd.conf.d/
- restart zabbix agent
- see Usage!

## Usage
- use logzab item like this for example: logzab[shorewalldropifin,eth0]
- logzab is the UserParameter, first parameter is the app, second parameter is optional and only needed when a selection is necessary, like with shorewalldropifin (i.e. the interface as selector)
- look in taillogit.bash for a list of available apps



