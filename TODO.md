# make sure offsets are being used correctly beyond logrotate
## implement check first line of offset file is inode, if logfile has different inode, rmoffset is being invoked. A new offset file will automatically be created next time taillogit runs for that app..
# setup possibility to reset offset by invoking logzab[appname,rmoffset], write function rmoffset

