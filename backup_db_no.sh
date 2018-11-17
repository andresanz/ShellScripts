#!/bin/bash

##
## Update/Edit first set of variables.
##
##
## USE: sudo sh backup_no_db.sh (local/s3) apache2 /etc/apache2 /home/ubuntu/backups
##

NOW=$(date +"%Y-%m-%d-%H%M")
FILENAME="$2.$NOW.tar"
HOME_FOLDER_NAME="$2"
HOME_FOLDER="$3"
EXCLUDE_FOLDERS="$4"

if [ $1 = "local" ]; then
BACKUP_DIR="/home/andre/backups"
ARCHIVEHOLD=7
TYPE=local
else
BACKUP_DIR="/mnt/s3"
ARCHIVEHOLD=35
TYPE=s3
fi

##
## NO EDITS BELOW 
##

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
WWW_TRANSFORM='s,^$HOME_FOLDER/$HOME_FOLDER_NAME,www,'
DB_TRANSFORM='s,^/$BACKUP_DIR/$HOME_FOLDER_NAME,database,'

##
## Make directory if it doesnt exist already
##

mkdir -p $BACKUP_DIR/$HOME_FOLDER_NAME

echo "Time: $(date). Backup of $TYPE $HOME_FOLDER_NAME STARTED" >> /home/andre/scripts/logs/BackupLog_$HOME_FOLDER_NAME.log

# Create the archive and the MySQL dump

if [ -z "$4" ]; then
sudo tar -cvf $BACKUP_DIR/$HOME_FOLDER_NAME/$FILENAME --transform $WWW_TRANSFORM $HOME_FOLDER 
else
sudo tar --exclude $EXCLUDE_FOLDERS -cvf $BACKUP_DIR/$HOME_FOLDER_NAME/$FILENAME --transform $WWW_TRANSFORM $HOME_FOLDER 
fi

# mysqldump --user=$DB_USER --password=$DB_PASS $DB_NAME > $BACKUP_DIR/$DB_FILE

# Append the dump to the archive, remove the dump and compress the whole archive.
# tar --append --file=$BACKUP_DIR/$FILE --transform $DB_TRANSFORM $BACKUP_DIR/$DB_FILE
# rm $BACKUP_DIR/$DB_FILE

sudo gzip -9 $BACKUP_DIR/$HOME_FOLDER_NAME/$FILENAME

##
## Erase backups older than $ARCHIVEHOLD days
##
find $BACKUP_DIR/$HOME_FOLDER_NAME -type f -mtime +$ARCHIVEHOLD -name '*.gz' -execdir rm -- '{}' \;

echo "Time: $(date). Backup of $TYPE $HOME_FOLDER_NAME ENDED" >> /home/andre/scripts/logs/BackupLog_$HOME_FOLDER_NAME.log
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> /home/andre/scripts/logs/BackupLog_$HOME_FOLDER_NAME.log

##
## Send logfile
##
mail -s "BackupLog $TYPE $HOME_FOLDER_NAME" sanz.andre@gmail.com < /home/andre/scripts/logs/BackupLog_$HOME_FOLDER_NAME.log








