#! /bin/bash

SHARE_DIRECTORY='/var/www'
SHARE_TTL=1hour
SHARE_URL_PATH='/'
SHARE_INTERFACE=''
AUTO_TEXT=false

function help {
  echo "Usage: share [file]"
}

function echo_share_link {
  pattern='\s*inet addr:\([0-9\.]*\).*$'
  escaped_replace=$(echo $SHARE_URL_PATH | sed 's/^\/$//;s/\//\\\//g')
  filename=$(basename "$2" | sed 's/\s/%20/g')

  ifconfig $1 2>/dev/null | sed -n "s/$pattern/http:\/\/\1$escaped_replace\/$filename/p"
}

function share_file {
  filename=$(basename "$1")

  is_text=$(file "$filename" | grep -c 'ASCII text')

  if [ "$AUTO_TEXT" == 'true' -a "$is_text" != '0' ]; then
    filename="$filename.txt"
  fi

  cp "$1" "$SHARE_DIRECTORY/$filename"
  if [ $? != 0 ]; then
    echo "Cannot copy file to directory \"$SHARE_DIRECTORY\""
    return
  fi

  echo "rm \"$SHARE_DIRECTORY/$filename\"" | at now+$SHARE_TTL 2>/dev/null
  if [ $? != 0 ]; then
    echo "Cannot plan file removal. Please delete the file manually"
  fi

  if [ -z $SHARE_INTERFACE ]; then
    interfaces=$(ifconfig -s | cut -d ' ' -f 1)
  else
    interfaces=$SHARE_INTERFACE
  fi

  for itf in $interfaces; do
    echo_share_link $itf "$filename"
  done
}

function get_config {
  if [ -f "/etc/sharerc" ]; then
    source "/etc/sharerc"
  fi

  if [ -f "$HOME/.sharerc" ]; then
    source "$HOME/.sharerc"
  fi
}

if [ -z "$1" ]; then
  help
elif [ -f "$1" ]; then
  get_config
  share_file "$1"
else
  echo "File $1 not found"
fi
