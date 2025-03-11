#!/bin/bash


for var in db_password db_root_password credentials; do
    if [ ! -f "/run/secrets/$var" ]; then
        echo "Missing secret: $var"
        exit 1
    fi
done

export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_USER=$(grep MYSQL_USER /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
export MYSQL_DATABASE=$(grep MYSQL_DATABASE /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')


service mariadb start 2> /dev/mariadb-error-output.txt

for i in {30..0}; do
    if mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" > /dev/mariadb-error-output.txt 2>&1; then
        echo "MariaDB is up and running"
        break
    fi
    echo -n "." && sleep 1
done

if [ $i -eq 0 ]; then
    echo -e "MariaDB startup failed!"
    exit 1
fi


mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "
    CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
    CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
    FLUSH PRIVILEGES;
    SHUTDOWN;
" || { echo "Database setup failed"; exit 1; }

echo "MariaDB setup completed successfully."

sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s|#log_error|log_error |g" /etc/mysql/mariadb.conf.d/50-server.cnf
exec "$@"
