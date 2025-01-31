#!/bin/bash
# a Backup tool for local or any Remote server
# A script by KASUN S.

#welcome users
user=$(whoami)
pwd=$(pwd)
host=$(hostname)
date=$(date)
echo
echo "Hello $user, You're currently in $pwd."
echo
sleep 2

# local or remote choice
echo "What do you want to do ?"
echo
echo "1. Local Backup"
echo "2. Remote Backup"
echo "3. Exit"
echo
read -p "Choice: " choice
echo

case $choice in
        1)
             read -p "What's directory path that needed to backup: " source_dir
             read -p "Where Do you Needed $source_dir backed up to(in $host): " backup_dir
             mkdir "$backup_dir"
             echo
             echo "Backing up files from $source_dir to $backup_dir..."
             cp -r "$source_dir"/* "$backup_dir"
             sleep 2
             echo
             # Loging the events
             host=$(hostname)
             date=$(date)
             local_ip=$(ip addr show | grep 'inet ' | awk '{print $2}' | tail -n 1)
             echo "[+](local) a user named[$user] in Your $host.Ran a Backup Operation,which backedup files in $source_dir to $backup_dir at Time[$date] " >> backup.log
             server=$(hostname)
             username=$(whoami)
                   ;;
        2)
                # ask the directory
                read -p "What's directory path that needed to backup: " source_dir

                # ask the Remote location
                read -p "Remote server ip/URL: " server
                read -p "Username of the remote server: " username
                read -p "Remote server's backup location: " backup_dir
                echo

                # Copy files to the backup directory
                echo "Backing up files from $source_dir to $backup_dir at server($server) ..."
                echo
                scp -r "$source_dir/"* "$username"@"$server":"$backup_dir"
                sleep 2

                # Loging the events
                host=$(hostname)
                date=$(date)
                local_ip=$(ip addr show | grep 'inet ' | awk '{print $2}' | tail -n 1)
                echo "[+](remote) a user named[$user] in Your $host($local_ip). backedup files in $source_dir to $backup_dir at $server, using the username[$username] at Time[$date] " >> backup.log
                echo "[+] a user named[$user] in $host($local_ip).backedup files in $source_dir(in $host) to $backup_dir at $server(Your Machine), using the username[$username] at Time[$date] " > READ.ME
                scp "$pwd/READ.ME" "$username"@"$server":"$backup_dir/READ.ME"
                rm READ.ME
                   ;;
        3)
                echo "Exting..."
                sleep 2
                echo "[+](exit) a User named[$user] Open the backup tool and exited at $date" >> backup.log
                exit
                   ;;
        *)
                echo "Invalid Option!!!"
                sleep 1
                echo "[+](invalid) a User named[$user] entered a Invalid Option at $date" >> backup.log
                exit
                   ;;

esac

# Final Message
date=$(date)
user=$(whoami)
echo
echo "-------------------------------------------------------------------------------------------------------------------------------------------------"
echo "all files in $source_dir are successfully Backuped to the $backup_dir at $username@$server in $date"
echo "-------------------------------------------------------------------------------------------------------------------------------------------------"
