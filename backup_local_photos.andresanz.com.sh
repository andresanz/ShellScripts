#!/bin/bash

##
## Update/Edit first set of variables.
##
NOW=$(date +"%Y-%m-%d-%H%M")
FILE="photos.andresanz.com.$NOW.tar"
BACKUP_DIR="/home/ubuntu/backups/photos.andresanz.com"
WWW_DIR="/var/www/html/photos.andresanz.com/"
DOMAIN_NAME="photos.andresanz.com"

##
## Edit/Update MySQL database credentials
##
DB_USER="photos"
DB_PASS="LtYzyLs5ckqF3tCa"
DB_NAME="photos"
DB_FILE="$DOMAIN_NAME.$NOW.sql"

##
## Tar transforms for better archive structure.
##
WWW_TRANSFORM='s,^var/www/html/$DOMAIN_NAME,www,'
DB_TRANSFORM='s,^home/ubuntu/backups/$DOMAIN_NAME,database,'

##
## Make directory if it doesnt exist already
##
mkdir -p /home/ubuntu/backups/$DOMAIN_NAME

echo "Time: $(date). Local backup of $DOMAIN_NAME STARTED" >> /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log

# Create the archive and the MySQL dump
tar -cvf $BACKUP_DIR/$FILE --transform $WWW_TRANSFORM $WWW_DIR
mysqldump --user=$DB_USER --password=$DB_PASS $DB_NAME > $BACKUP_DIR/$DB_FILE

# Append the dump to the archive, remove the dump and compress the whole archive.
tar --append --file=$BACKUP_DIR/$FILE --transform $DB_TRANSFORM $BACKUP_DIR/$DB_FILE
rm $BACKUP_DIR/$DB_FILE
gzip -9 $BACKUP_DIR/$FILE

##
## Erase backups older than 7 days
##
find $BACKUP_DIR/ -type f -mtime +7 -name '*.gz' -execdir rm -- '{}' \;

echo "Time: $(date). Local backup of $DOMAIN_NAME ENDED" >> /home/ubuntu/scripts/logs//BackupLog_$DOMAIN_NAME.log
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log

##
## Send logfile
##
mail -s "BackupLog_$DOMAIN_NAME" sanz.andre@gmail.com < /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log








