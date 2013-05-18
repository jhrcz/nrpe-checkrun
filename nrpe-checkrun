#!/bin/bash

CHECK=$1
if [ -z "$2" ]
then
	HOST=127.0.0.1
else
	HOST="$2"
fi

[ -n "$CHECK" ] \
	|| exit 2
[ -n "$HOST" ] \
	|| exit 2

/usr/lib64/nagios/plugins/check_nrpe -H "$HOST" -c "$CHECK"

