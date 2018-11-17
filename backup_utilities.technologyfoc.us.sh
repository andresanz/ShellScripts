#!/bin/bash

##
## Update/Edit first set of variables.
##
NOW=$(date +"%Y-%m-%d-%H%M")
FILE="utilities.$NOW.tar"
BACKUP_DIR="/mnt/s3/utilities.technologyfoc.us"
WWW_DIR="/var/www/html/utilities.technologyfoc.us/"
DOMAIN_NAME="utilities.technologyfoc.us"

##
## Edit/Update MySQL database credentials
##
# DB_USER=""
# DB_PASS=""
# DB_NAME=""
# DB_FILE=""

##
## Tar transforms for better archive structure.
##
WWW_TRANSFORM='s,^etc/utilities/$DOMAIN_NAME,www,'
DB_TRANSFORM='s,^mnt/s3/$DOMAIN_NAME,database,'

##
## Make directory if it doesnt exist already
##
mkdir -p /mnt/s3/$DOMAIN_NAME

echo "Time: $(date). Backup of $DOMAIN_NAME STARTED" >> /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log

# Create the archive and the MySQL dump
sudo tar -cvf $BACKUP_DIR/$FILE --transform $WWW_TRANSFORM $WWW_DIR
# mysqldump --user=$DB_USER --password=$DB_PASS $DB_NAME > $BACKUP_DIR/$DB_FILE

# Append the dump to the archive, remove the dump and compress the whole archive.
# tar --append --file=$BACKUP_DIR/$FILE --transform $DB_TRANSFORM $BACKUP_DIR/$DB_FILE
# rm $BACKUP_DIR/$DB_FILE
sudo gzip -9 $BACKUP_DIR/$FILE

##
## Erase backups older than 7 days
##
find $BACKUP_DIR/ -type f -mtime +7 -name '*.gz' -execdir rm -- '{}' \;

echo "Time: $(date). Backup of $DOMAIN_NAME ENDED" >> /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log

##
## Send logfile
##
mail -s "BackupLog_$DOMAIN_NAME" sanz.andre@gmail.com < /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log








