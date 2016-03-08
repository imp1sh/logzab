#!/bin/bash
# taillogit.bash
# this is where the script itself resides. Also the config file should be there actually
scriptdir="$(dirname "$0")"
function checktwo {
	if [ -z "$2" ]; then
        	echo "the necessary parameter two is not given. Please RTFM and retry."
        	exit 3
        fi
}
if [ -f $scriptdir/config.bash ]; then
	source $scriptdir/config.bash
	# echo "inhaled config file $scriptdir/config.bash"
else
	echo "File config.bash not in working directory. Working directory is $scriptdir"
	exit 1
fi

# first parameter given in the userparameter command is the logfile in which we would like to search
# second parameter is offset filename. this parameter might conflict, so we just check if it's already taken and if so, just don't do the userparameter but exit with !=0
# third parameter is the expression 
#if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
if [ -z "$1" ]; then
	echo "the necessary parameters are not given. Please RTFM and retry."
	exit 2
else
	#logfilepath=$1
	application=$1
	expression=$2

	# differ between applications here
	case "$1" in
	shorewalldropifout)
		checktwo $1 $2
		sudo $logtailpath -f "${shorewalldropifout[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${shorewalldropifout[2]}" | $greppath -c "OUT=$expression"
		;;
	shorewalldropifin)
		checktwo $1 $2
		sudo $logtailpath -f "${shorewalldropifin[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${shorewalldropifin[2]}" | $greppath -c "IN=$expression"
		;;
	dovecotpop3login)
		sudo $logtailpath -f "${dovecotpop3login[0]}"  -o "$scriptdir/$offsetspath/$1$2" | $greppath -c "${dovecotpop3login[2]}"
		;;
	dovecotimaplogin)
		sudo $logtailpath -f "${dovecotimaplogin[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath -c "${dovecotimaplogin[2]}"
		;;
	fail2bansshban)
		sudo $logtailpath -f "${fail2bansshban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bansshban[2]}" | $greppath -c Ban
		;;
	fail2bansshunban)
		sudo $logtailpath -f "${fail2bansshunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bansshunban[2]}" | $greppath -c Unban
		;;
	fail2bandovecotban)
		sudo $logtailpath -f "${fail2bandovecotban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bandovecotban[2]}" | $greppath -c Ban
		;;
	fail2bandovecotunban)
		sudo $logtailpath -f "${fail2bandovecotunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bandovecotunban[2]}" | $greppath -c Unban
		;;
	fail2banpostfixban)
		sudo $logtailpath -f "${fail2banpostfixban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2banpostfixban[2]}" | $greppath -c Ban
		;;
	fail2banpostfixunban)
		sudo $logtailpath -f "${fail2banpostfixunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2banpostfixunban[2]}" | $greppath -c Unban
		;;
	fail2banpostfixsaslban)
		sudo $logtailpath -f "${fail2banpostfixsaslban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2banpostfixsaslban[2]}" | $greppath -c Ban
		;;
	fail2banpostfixsaslunban)
		sudo $logtailpath -f "${fail2banpostfixsaslunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2banpostfixsaslunban[2]}" | $greppath -c Unban
		;;
	fail2bansieveban)
		sudo $logtailpath -f "${fail2bansieveban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bansieveban[2]}" | $greppath -c Ban
		;;
	fail2bansieveunban)
		sudo $logtailpath -f "${fail2bansieveunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bansieveunban[2]}" | $greppath -c Unban
		;;	
	postfixreceived)
		sudo $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixreceived[2]}" -A 22 | $greppath -v byte | $greppath "${postfixreceived[3]}" | awk '{print $1}'
		;;
	postfixdevlivered)
		;;
	postfixforwarded)
		;;
	postfixdeferred)
		;;
	postfixbounced)
		;;
	postfixrejected)
		;;
	postfixrejecttwarning)
		;;
	postfixheld)
		;;
	postfixdiscarded)
		;;
	postfixreceivedkbyte)
		;;
	postfixdeliveredkbyte)
		;;
	postfixsenders)
		;;
	postfixsendinghosts)
		;;
	postfixrecipients)
		;;
	postfixrecipienthosts)
		;;
	*)
		echo "something went wrong, probably wrong application selected."
		;;
	esac
fi

