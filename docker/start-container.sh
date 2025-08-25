#!/bin/sh

set -e

# Wait for the web server to start
sleep 15

APPS="\
    twofactor_totp \
    contacts \
    calendar \
    passman \
    richdocumentscode \
    richdocuments \
    metadata \
    deck \
    files_archive \
    drawio \
    spreed \
"

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
    
    # add hostname to trusted domains
    php /var/www/html/occ config:system:set trusted_domains 1 --value=$(hostname)

    echo "Nextcloud configuration started."

    for app in ${APPS}; do
        php /var/www/html/occ app:install "${app}" || true
        php /var/www/html/occ app:enable "${app}"  || true
    done

    echo "Nextcloud setup completed."
else
    echo "Nextcloud is already installed."
    echo "Checking apps installed also."

    for app in ${APPS}; do
        php /var/www/html/occ app:install "${app}" || true
        php /var/www/html/occ app:enable "${app}"  || true
    done
fi

if [ -n "${NEXTCLOUD_TRUSTED_DOMAINS}" ]; then
    i=2
    for item in ${NEXTCLOUD_TRUSTED_DOMAINS}; do
        php /var/www/html/occ config:system:set trusted_domains "${i}" --value="${item}"
        i=$((i + 1))
    done
fi

chown -R www-data:www-data /var/www/html

echo "Nextcloud init finished."
