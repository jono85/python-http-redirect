#!/bin/bash

CERT_CONFIG=''
PROTOCOL='HTTP'

if [[ $USE_SELF_SIGNED_SSL == 'true' ]]
then	
	echo ""
	echo " --- Generating Self-signed SSL certificate --- "
	rm -rf /etc/sslkeys
	mkdir /etc/sslkeys
	openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
	    -subj "/C=IE/ST=SomeState/L=SomeCity/O=SomeOrganisation/CN=*.redirector.int" \
	    -keyout /etc/sslkeys/server.key -out /etc/sslkeys/server.crt
	echo ""
	CERT_CONFIG="--certfile=/etc/sslkeys/server.crt --keyfile=/etc/sslkeys/server.key"
	PROTOCOL='HTTPS'
fi

pkill gunicorn #kill any running gunicorn processes if present

echo "Starting Gunicorn server ($PROTOCOL on TCP $SERVER_PORT) with $THREADS_COUNT threads and $REQUEST_TIMEOUT secs request timeout."
gunicorn --bind 0.0.0.0:$SERVER_PORT -w $THREADS_COUNT --graceful-timeout $REQUEST_TIMEOUT --timeout $REQUEST_TIMEOUT $CERT_CONFIG guniapp:app
