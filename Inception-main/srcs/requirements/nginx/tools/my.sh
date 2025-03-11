#!/bin/bash
sed -i "s|!DOMAIN!|$DOMAIN_NAME|g" /etc/nginx/nginx.conf

if [ ! -f /etc/nginx/ssl/nginx.key ] || [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
		-keyout /etc/nginx/ssl/nginx.key \
		-out /etc/nginx/ssl/nginx.crt \
		-subj "/C=TR/ST=Istanbul/L=Istanbul/O=42 School/OU=Student/CN=$DOMAIN_NAME"
else
	echo "SSL certificate already exists."
fi

exec "$@"
