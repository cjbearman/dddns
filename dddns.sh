#!/bin/sh

# The HOST variable is required to define the host to be updated
if [ -z "$HOST" ]; then
	echo "Failure: Must define HOST"
	exit 1
fi

# The USERNAME variable is required to define the dyndns username
if [ -z "$USERNAME" ]; then
	echo "Failure: Must define USER"
	exit 1
fi

# The APIKEY variable is required to define the dyndns API key
if [ -z "$APIKEY" ]; then
	echo "Failure: Must define APIKEY"
	exit 1
fi

# The interval is optional (default 600) seconds between check/update cycles
if [ -z "$INTERVAL" ]; then
	INTERVAL=600
fi

# Default options for DIG
DIGOPTS=""

echo "Configuration:"
echo "HOST = ${HOST}"
echo "USERNAME = ${USERNAME}"
echo "APIKEY = <Not Logged>"
echo "INTERVAL = ${INTERVAL} seconds"

# RESOLVER is optional but should be used as the IP address for the 
# DNS resolver to use, if provided
if [ -z "$RESOLVER" ]; then
	echo "RESOLVER = <Default>"
else
	DIGOPTS="@${RESOLVER}"
	echo "RESOLVER = ${RESOLVER}"
fi

# Go until something fails
while true
do
	# Dig out the current DNS address
	dns=`dig $DIGOPTS +noall +answer in a ${HOST} | awk '$4 == "A" {print $5}' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'`
	if [ $? -ne 0 ]; then
		echo "Non zero result from dig, container will exit"
		exit 2
	fi
	if [ "$dns" == "" ]; 
		then 
		echo "Failure resolving ${HOST} via DNS. Container will exit"
		exit 2
	fi

	# Use checkip.dyndns.com to get current IP
	actual=`curl -s "http://checkip.dyndns.com" | sed -nr 's/.*: ([0-9\.]+).*/\1/p'`
	if [ $? -ne 0 ]; then
		echo "Non zero result from curl, container will exit"
		exit 2
	fi
	if [ "$actual" == "" ]; then
		echo "Failure resolving ${HOST} via lookup server. Container will exit"
		exit 2
	fi

	if [ "$dns" == "$actual" ]; then
		# No update needed
		echo "IP Address of ${actual} is current, no update"
	else
		# Update is needed
		echo "IP Address of ${dns} is out of date, actual is ${actual}, will update"
	
		RESULT=`curl -X GET -s -G -u "${USERNAME}:${APIKEY}" --data-urlencode "hostname=${HOST}" --data-urlencode "myip=${actual}" "https://members.dyndns.org/v3/update" | awk '{print $1}'`
	
		if [ $? -ne 0 ]; then
			echo "Failure curl update. Container will exit"
			exit 2
		fi
	
		case "$RESULT" in
			"good")
				echo "IP Updated successfully";;
			"nochg")
				echo "No change was needed";;
			"badauth") 
				echo "Failed authentication. container will exit"; exit 2;;
			*)
				echo "Unexpected result:";
				echo $RESULT
				echo "Container will exit"; 
				exit 2
		esac
	fi
			
	# Sleep until next cycle
	sleep $INTERVAL
done
