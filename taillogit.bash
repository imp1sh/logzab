#!/bin/bash
# taillogit.bash
# this is where the script itself resides. Also the config file should be there actually

scriptdir="$(dirname "$0")"
# get config
if [ -f $scriptdir/config.bash ]; then
	source $scriptdir/config.bash
	# echo "inhaled config file $scriptdir/config.bash"
else
	echo "File config.bash not in working directory. Working directory is $scriptdir"
	exit 1
fi

# functions
function checkone {
	if [ -z "$1" ]; then
        	echo "the necessary parameter one is not given. Please RTFMoSC and retry."
        	return 1
	else
		return 0
        fi
}
function checkinode {
	# 1st parameter: offset file full or relative path
	# 2nd parameter: log file full or relative path
	# echo "$1"
	# echo "$2"
	if [ $(head -1 $1) -eq $(ls -i $2|awk '{print $1}') ]; then
		# yes, inode identical, meaning logfile hasn't rotated
		# echo "inode from offset $(head -1 $1)"
		# echo "inode from logfile $(ls -i $2|awk '{print $1}')" 
		return 0
	else
		return 1
	fi
}
function checkall {
# 1st parameter is 1st parameter of taillog.bash which is app name $1
# 2nd parameter is 2nd parameter of taillog.bash $2
# 3rd parameter is offset path "$scriptdir/$offsetspath/$1$2"
# 4th parameter is logfile path "${shorewalldropifin[0]}"
# 5th parameter is logtail path $logtailpath
# 6th parameter is grep path $greppath
# 7th parameter is taillogits 2nd parameter which is grepping for app "${shorewalldropifin[2]}"
# 8th parameter is taillogits 3rd parameter which is the so called expression or filter $expression
# return value is 0 if it's ok to run app
# return value is 1 if something went wrong and it's not ok to run app
	
	# check if appname is given. If not we cannot work
	checkone $1
	if [ $? -eq 0 ]; then
		# check if logrotate has hit
		#echo "offset $3"
		#echo "log $4"
		if [ -f $3 ] && [ -f $4 ]; then
	                checkinode "$3" "$4"
			if [ "$?" -eq 0 ]; then
				# check if logfile exist
				# just echo the following line, if you're curious about what it does, it's just a taillog with some greps
                	        return 0
			else
				rm -f "$3"
				return 0
			fi
		elif [ -f $4 ]; then
			return 0
		else
			echo "obvisouly doesn logfile not exist at $4 nor does offset file at $3"
			return 1
		fi
	else
		# exit 2 if first parameter appended to taillogit.bash is missing
		echo "the necessary parameters are not given. Please RTFM and retry."
		exit 2
	fi
}

# first parameter given in the userparameter command is the logfile in which we would like to search
# second parameter is offset filename. this parameter might conflict, so we just check if it's already taken and if so, just don't do the userparameter but exit with !=0
# third parameter is the expression 
#if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
checkone "$1"
if [ ! $? -eq 0 ]; then
	echo "the necessary parameters are not given. Please RTFM and retry."
	exit 2
else
	#logfilepath=$1
	application=$1
	expression=$2

	# differ between applications here
	case "$1" in
	shorewalldropifout)
		checkall  "$1" "$2"  "$scriptdir/$offsetspath/$1$2" "${shorewalldropifout[0]}"
		if [ $? -eq 0 ]; then
			$logtailpath -f "${shorewalldropifout[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${shorewalldropifout[2]}" | $greppath -c "OUT=$expression"
		else
			exit 3
		fi
		;;
	shorewalldropifin)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${shorewalldropifin[0]}"
		if [ $? -eq 0 ]; then
			 $logtailpath -f "${shorewalldropifin[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${shorewalldropifin[2]}" | $greppath -c "IN=$expression"
		else
			exit 3
		fi
		;;
	dovecotpop3login)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${dovecotpop3login[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${dovecotpop3login[0]}"  -o "$scriptdir/$offsetspath/$1$2" | $greppath -c "${dovecotpop3login[2]}"
		else
			exit 3
		fi
		;;
	dovecotimaplogin)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${dovecotimaplogin[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${dovecotimaplogin[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath -c "${dovecotimaplogin[2]}"
		else
			exit 3
		fi
		;;
	fail2bansshban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2bansshban[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${fail2bansshban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bansshban[2]}" | $greppath -c Ban
		else
			exit 3
		fi
		;;
	fail2bansshunban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2bansshunban[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${fail2bansshunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bansshunban[2]}" | $greppath -c Unban
		else
			exit 3
		fi
		;;
	fail2bandovecotban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2bandovecotban[0]}"
                if [ $? -eq 0 ]; then	
			 $logtailpath -f "${fail2bandovecotban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bandovecotban[2]}" | $greppath -c Ban
		else
			exit 3
		fi
		;;
	fail2bandovecotunban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2bandovecotunban[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${fail2bandovecotunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bandovecotunban[2]}" | $greppath -c Unban
		else
			exit 3
		fi
		;;
	fail2banpostfixban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2banpostfixban[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${fail2banpostfixban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2banpostfixban[2]}" | $greppath -c Ban
		else
			exit 3
		fi
		;;
	fail2banpostfixunban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2banpostfixunban[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${fail2banpostfixunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2banpostfixunban[2]}" | $greppath -c Unban
		else
			exit 3
		fi
		;;
	fail2banpostfixsaslban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2banpostfixsaslban[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${fail2banpostfixsaslban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2banpostfixsaslban[2]}" | $greppath -c Ban
		else
			exit 3
		fi
		;;
	fail2banpostfixsaslunban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2banpostfixsaslunban[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${fail2banpostfixsaslunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2banpostfixsaslunban[2]}" | $greppath -c Unban
		else
			exit 3
		fi
		;;
	fail2bansieveban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2bansieveban[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${fail2bansieveban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bansieveban[2]}" | $greppath -c Ban
		else
			exit 3
		fi
		;;
	fail2bansieveunban)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${fail2bansieveunban[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${fail2bansieveunban[0]}" -o "$scriptdir/$offsetspath/$1$2" | $greppath "${fail2bansieveunban[2]}" | $greppath -c Unban
		else
			exit 3
		fi
		;;	
	postfixreceived)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixreceived[0]}"
                if [ $? -eq 0 ]; then
			 sudo $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixreceived[1]}" -A 22 | $greppath -v byte | $greppath "${postfixreceived[2]}" | awk '{print $1}'
		else
			exit 3
		fi
		;;
	postfixdelivered)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixdevlivered[0]}"
		if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixdevlivered[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixdevlivered[1]}" -A 22 | $greppath -v byte | $greppath "${postfixdevlivered[2]}" | awk '{print $1}'
		else
			exit 3
		fi
		;;
	postfixforwarded)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixforwarded[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixforwarded[1]}" -A 22 | $greppath "${postfixforwarded[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixdeferred)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixdeferred[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixdeferred[1]}" -A 22 | $greppath "${postfixdeferred[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixbounced)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixbounced[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixbounced[1]}" -A 22 | $greppath "${postfixbounced[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixrejected)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixrejected[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixrejected[1]}" -A 22 | $greppath "${postfixrejected[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixrejectwarning)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixrejecttwarning[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixrejecttwarning[1]}" -A 22 | $greppath "${postfixrejecttwarning[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixheld)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixheld[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixheld[1]}" -A 22 | $greppath "${postfixheld[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixdiscarded)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixdiscarded[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixdiscarded[1]}" -A 22 | $greppath "${postfixdiscarded[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixreceivedkbyte)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixreceivedkbyte[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixreceivedkbyte[1]}" -A 22 | $greppath "${postfixreceivedkbyte[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixdeliveredkbyte)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixdeliveredkbyte[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixdeliveredkbyte[1]}" -A 22 | $greppath "${postfixdeliveredkbyte[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixsenders)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixsenders[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixsenders[1]}" -A 22 | $greppath "${postfixsenders[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixsendinghosts)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixsendinghosts[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixsendinghosts[1]}" -A 22 | $greppath "${postfixsendinghosts[2]}" | awk '{print $1}'
                else
                        exit 3
                fi

		;;
	postfixrecipients)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixrecipients[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixrecipients[1]}" -A 22 | $greppath "${postfixrecipients[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	postfixrecipienthosts)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${postfixrecipienthosts[0]}"
                if [ $? -eq 0 ]; then
			 $logtailpath -f "${postfixreceived[0]}" -o "$scriptdir/$offsetspath/$1$2" | $pflogsummpath -d today | $greppath "${postfixrecipienthosts[1]}" -A 22 | $greppath "${postfixrecipienthosts[2]}" | awk '{print $1}'
                else
                        exit 3
                fi
		;;
	apache200)
		checkall "$1" "$2" "$scriptdir/$offsetspath/$1$2" "${apache200[0]}"
	*)
		echo "something went wrong, probably wrong application selected."
		;;
	esac
fi

