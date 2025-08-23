#!/bin/sh

set -e

# Wait for the web server to start
sleep 10

# Check if Nextcloud is installed
if [ ! -f /var/www/html/config/config.php ]; then
    echo "Nextcloud is not installed. Started installation..."
    ADMIN_USER_PASSWORD=$(cat /run/secrets/admin_user_password)
    if [ -z $ADMIN_USER_PASSWORD ];
    then
        echo "ADMIN_USER_PASSWORD is not set"
        exit 1
    fi

    DATABASE_PASSWORD=$(cat /run/secrets/mysql_password)
    if [ -z $DATABASE_PASSWORD ];
    then
        echo "DATABASE_PASSWORD is not set"
        exit 1
    fi

    cp -r /usr/src/nextcloud/* /var/www/html/

    php /var/www/html/occ maintenance:install \
    --database="mysql" \
    --database-name="${MYSQL_DATABASE}" \
    --database-host="${MARIADB_HOST_NAME}" \
    --database-user="${MYSQL_USER}" \
    --database-pass="${DATABASE_PASSWORD}" \
    --admin-user="admin" \
    --admin-pass="${ADMIN_USER_PASSWORD}"

    echo "Nextcloud configuration started."

    php /var/www/html/occ app:enable twofactor_totp
    php /var/www/html/occ app:enable contacts
	php /var/www/html/occ app:enable calendar
    php /var/www/html/occ app:install passman
    php /var/www/html/occ app:install richdocumentscode
	php /var/www/html/occ app:install richdocuments
	php /var/www/html/occ app:install metadata
	php /var/www/html/occ app:install deck
	php /var/www/html/occ app:install files_archive
	php /var/www/html/occ app:install drawio
	php /var/www/html/occ app:install spreed
    php /var/www/html/occ config:system:set trusted_domains 1 --value=$(hostname)

    chown -R www-data:www-data /var/www/html

    echo "Nextcloud configuration finished."
else
    echo "Nextcloud is already installed."
fi

if [ -n "${NEXTCLOUD_TRUSTED_DOMAINS}" ]; then
    i=2
    for item in ${NEXTCLOUD_TRUSTED_DOMAINS}; do
        php /var/www/html/occ config:system:set trusted_domains "${i}" --value="${item}"
        i=$((i + 1))  # Increment the index
    done
fi

chown -R www-data:www-data /var/www/html/config

echo "Nextcloud setup completed."