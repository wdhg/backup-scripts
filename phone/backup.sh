BACKUPS_DIR=~/backups/phone
TARGET_DIRS=(/sdcard/Snapchat /sdcard/Pictures /sdcard/DCIM)

if [ $(adb get-state)  != "device" ]
then
  echo "Make sure device is authorised"
  exit
fi

echo "Starting phone backup..."

for target_dir in ${TARGET_DIRS[*]}
do
  echo "Backing up $target_dir to $BACKUPS_DIR$target_dir..."

  files=$(adb shell find $target_dir -type f)

  for target_file in ${files[*]}
  do
    backup_file="$BACKUPS_DIR$target_file"
    backup_file_dir=$(dirname $backup_file)
    # check if files backup directory exists
    if [ ! -d $backup_file_dir ];
    then
      mkdir -p $backup_file_dir
    fi
    if [ ! -f $backup_file ];
    then
      adb pull $target_file $backup_file
    fi
  done
done

echo "Backup complete"
