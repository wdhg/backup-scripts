BACKUPS_DIR=~/backups/phone
TARGET_DIRS=(/sdcard/Snapchat /sdcard/Pictures /sdcard/DCIM /sdcard/Movies /sdcard/Download /sdcard/WhatsApp)

if [ $(adb get-state)  != "device" ]
then
  echo "Make sure device is authorised"
  exit
fi

echo "Starting phone backup..."

for target_dir in ${TARGET_DIRS[*]}
do
  echo ""
  echo "Backing up $target_dir to $BACKUPS_DIR$target_dir..."
  echo ""

  IFS=$'\n' # set for loop delimeter to newline
  for target_file in $(adb shell find "$target_dir" -type f)
  do
    backup_file="$BACKUPS_DIR$target_file"
    backup_file_dir=$(dirname $backup_file)
    # check if files backup directory exists
    if [ ! -d "$backup_file_dir" ];
    then
      mkdir -p "$backup_file_dir"
    fi
    if [ ! -f "$backup_file" ];
    then
      adb pull "$target_file" "$backup_file"
    fi
  done
done

echo "Backup complete"
