#!/bin/bash

CHECK=$1
HOST=127.0.0.1

[ -n "$CHECK" ] \
	|| exit 2
[ -n "$HOST" ] \
	|| exit 2

/usr/lib64/nagios/plugins/check_nrpe -H "$HOST" -c "$CHECK"

