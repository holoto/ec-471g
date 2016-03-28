#!/bin/sh

ChangeSymlink()
{
    if [ ! -d /usr/local/bin ]; then
        mkdir /usr/local/bin
    fi
    
    if [ "$symlinkTask" == "Create Symlink" ]; then
        ln -s "$scriptLocation" /usr/local/bin/darwindumper
        echo "Created symlink /usr/local/bin/darwindumper pointing to $scriptLocation"
    elif [ "$symlinkTask" == "Update Symlink" ]; then
        rm /usr/local/bin/darwindumper
        ln -s "$scriptLocation" /usr/local/bin/darwindumper
        echo "Update symlink /usr/local/bin/darwindumper to point to $scriptLocation"
    elif [ "$symlinkTask" == "Delete Symlink" ]; then
        rm /usr/local/bin/darwindumper
        echo "Deleted symlink /usr/local/bin/darwindumper"
    fi
}

ChangeDumpFolderOwnPerm()
{
    chown "${DD_BOSS}":"${DD_BOSSGROUP}" "$appContainingFolder"    
    chmod -R 755 "$appContainingFolder" 
}

CreateReportsFolderSetPerms()
{
    mkdir "$folderPath"
    chown "${DD_BOSS}":"${DD_BOSSGROUP}" "$folderPath"    
    chmod -R 755 "$folderPath" 
}

whichFunction="$1"
echo ""

case "$whichFunction" in
    "Symlink" )              scriptLocation="$2"
                             symlinkTask="$3"
                             ChangeSymlink
                             ;;
    "OwnPerm" )              DD_BOSS="$2"
                             DD_BOSSGROUP="$3"
                             appContainingFolder="$4"
                             ChangeDumpFolderOwnPerm
                             ;;
    "CreateFolderSetPerms" ) DD_BOSS="$2"
                             DD_BOSSGROUP="$3"
                             folderPath="$4"
                             CreateReportsFolderSetPerms
                             ;;
esac


