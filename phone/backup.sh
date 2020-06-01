BACKUPS_DIR=~/backups/phone
TARGET_DIRS=(/sdcard/Snapchat /sdcard/Pictures)

if [ $(adb get-state)  != "device" ]
then
  echo "Make sure device is authorised"
  exit
fi

echo "Starting backup..."

for target_dir in ${TARGET_DIRS[*]}
do
  backup_dir="${BACKUPS_DIR}/$(basename $target_dir)"
  echo "Backing up $target_dir to $backup_dir..."

  # check if back directory exists
  if [ ! -d $backup_dir ];
  then
    mkdir $backup_dir
  fi

  # i dont pull the entire directory
  # if it is important that files be overwritten
  # uncomment the next line and comment out the rest

  # adb pull $target_dir $backup_dir

  file=$(adb shell ls $target_dir)

  for file in ${file[*]}
  do
    target_file="$target_dir/$file"
    backup_file="$backup_dir/$file"
    if [ ! -f $backup_file ];
    then
      adb pull $target_file $backup_file
    fi
  done
done

echo "Backup complete"
