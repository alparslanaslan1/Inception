#!/bin/bash

GREEN='\033[32m'
RESET='\033[0m'


chown -R www-data: /var/www/*
chmod -R 755 /var/www/*
mkdir -p /run/php/
touch /run/php/php7.4-fpm.pid
chown -R www-data:www-data /var/www/html/

if [ -f /run/secrets/credentials ]; then
	export MYSQL_USER=$(grep MYSQL_USER /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export MYSQL_DATABASE=$(grep MYSQL_DATABASE /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_ADMIN_LOGIN=$(grep WP_ADMIN_LOGIN /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_ADMIN_PASSWORD=$(grep WP_ADMIN_PASSWORD /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_ADMIN_EMAIL=$(grep WP_ADMIN_EMAIL /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export MAIL_EXTENTION=$(grep MAIL_EXTENTION /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_USER_LOGIN=$(grep WP_USER_LOGIN /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_USER_PASSWORD=$(grep WP_USER_PASSWORD /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
fi

if [ -f /run/secrets/db_password ]; then
	export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$WP_USER_LOGIN" ] || [ -z "$WP_ADMIN_PASSWORD" ] ||\
	 [ -z "$WP_ADMIN_LOGIN" ] || [ -z "$WP_ADMIN_EMAIL" ] || [ -z "$MAIL_EXTENTION" ] || [ -z "$WP_USER_PASSWORD" ]; then
	exit 1
fi


max_attempts=10
attempt=1
until mysql -h mariadb -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;" > /dev/error_log.txt 2>&1; do
	    if [ $attempt -eq $max_attempts ]; then
	        exit 1
	    fi
	    attempt=$(( $attempt + 1 ))
	    sleep 2
done

echo -e "${GREEN}MariaDB hazır.${RESET}"

if [ ! -f /var/www/html/wp-config.php ]; then

	wp-cli core download --allow-root;

	wp-cli config create --allow-root \
	    --dbname=$MYSQL_DATABASE \
	    --dbuser=$MYSQL_USER \
	    --dbpass=$MYSQL_PASSWORD \
	    --dbhost=mariadb;

	wp-cli core install --allow-root \
	    --url=$DOMAIN_NAME \
	    --title=$WP_TITLE \
	    --admin_user=$WP_ADMIN_LOGIN \
	    --admin_password=$WP_ADMIN_PASSWORD \
	    --admin_email=$WP_ADMIN_EMAIL;

	wp-cli user create --allow-root \
	    "$WP_USER_LOGIN" "$MAIL_EXTENTION" \
	    --user_pass="$WP_USER_PASSWORD"

	echo -e "${GREEN}WordPress installation completed successfully.${RESET}"
else
	echo -e "${GREEN}WordPress is already installed.${RESET}"
fi

exec "$@"
