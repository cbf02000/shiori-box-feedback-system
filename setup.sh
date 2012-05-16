#!/bin/sh

rm -rf ./feedback/upload/temp.jpg
rm -rf ./feedback/upload/resized/*

chmod -R 755 ./*

chmod -R 777 ./db
chmod -R 777 ./feedback/upload

RESET_PATIENTS="UPDATE patients SET new=0;"
RESET_MESSAGES="DELETE FROM messages;"
COMMAND="sqlite3 ./db/feedback.db"

echo $RESET_PATIENTS | $COMMAND
echo $RESET_MESSAGES | $COMMAND
exit 0
