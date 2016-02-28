#!/bin/bash
# this is where the script itself resides. Also the config file should be there actually
scriptdir="$(dirname "$0")"
if [ -f $scriptdir/config.bash ]; then
	source $scriptdir/config.bash
	echo "inhaled config file $scriptdir/config.bash"
else
	echo "File config.bash not in working directory. Working directory is $scriptdir"
fi

# first parameter given in the userparameter command is the logfile in which we would like to search
# second parameter is offset filename. this parameter might conflict, so we just check if it's already taken and if so, just don't do the userparameter but exit with !=0
# third parameter is the expression 
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
	echo "the necessary parameters are not given. Please RTFM and retry."
	exit 1
else
	logfilepath=$1
	offsetfilename=$2
	expression=$3
	$(sudo "$logtailpath" -f "$logfilepath" -o "$scriptdir/$offsetspath/$offsetfilename") $(| $expression)
fi

