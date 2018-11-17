#!/bin/bash

##
## Update/Edit first set of variables.
##
NOW=$(date +"%Y-%m-%d-%H%M")
FILE="blog.andresanz.com.$NOW.tar"
BACKUP_DIR="/mnt/s3/blog.andresanz.com"
WWW_DIR="/var/www/html/blog.andresanz.com/"
DOMAIN_NAME="blog.andresanz.com"

##
## Edit/Update MySQL database credentials
##
DB_USER="blog"
DB_PASS="GLFc70G8tjuvLNB7"
DB_NAME="blog"
DB_FILE="$DOMAIN_NAME.$NOW.sql"

##
## Tar transforms for better archive structure.
##
WWW_TRANSFORM='s,^var/www/html/$DOMAIN_NAME,www,'
DB_TRANSFORM='s,^mnt/s3/$DOMAIN_NAME,database,'

##
## Make directory if it doesnt exist already
##
mkdir -p /mnt/s3/$DOMAIN_NAME

echo "Time: $(date). Backup of $DOMAIN_NAME STARTED" >> /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log

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

echo "Time: $(date). Backup of $DOMAIN_NAME ENDED" >> /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log

##
## Send logfile
##
mail -s "BackupLog_$DOMAIN_NAME" sanz.andre@gmail.com < /home/ubuntu/scripts/logs/BackupLog_$DOMAIN_NAME.log








