#!/bin/bash

##
## Update/Edit first set of variables.
##
NOW=$(date +"%Y-%m-%d-%H%M")

## FILE="photos.andresanz.com.$NOW.tar"
## BACKUP_DIR="/home/ubuntu/backups/photos.andresanz.com"
## WWW_DIR="/var/www/html/photos.andresanz.com/"
## DOMAIN_NAME="photos.andresanz.com"

##
## Edit/Update MySQL database credentials
##
DB_USER="photos"
DB_PASS="LtYzyLs5ckqF3tCa"
DB_NAME="photos"
DB_FILE="$DOMAIN_NAME.$NOW.sql"

### Tar files
tar -cvf /home/ubuntu/backups/photos.andresanz.com/$NOW.photos.andresanz.com.tar /var/www/html/photos.andresanz.com/

mysqldump --user=$DB_USER --password=$DB_PASS $DB_NAME > /home/ubuntu/backups/photos.andresanz.com/$NOW.database.photos.andresanz.com.sql

tar -rf /home/ubuntu/backups/photos.andresanz.com/$NOW.photos.andresanz.com.tar /home/ubuntu/backups/photos.andresanz.com/$NOW.database.photos.andresanz.com.sql

rm /home/ubuntu/backups/photos.andresanz.com/$NOW.database.photos.andresanz.com.sql

gzip -9 /home/ubuntu/backups/photos.andresanz.com/$NOW.photos.andresanz.com.tar




