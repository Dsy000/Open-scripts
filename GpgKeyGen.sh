#!/bin/bash
# Created by @deepak_yadav.
# bash GpgKeyGen.sh -m email@example.com -n name -t RSA -s 4096 -l <directorypath> -p pubring.gpg -r secring.gpg -x 1d
# -n   name of key pair
# -m   mail of key paire
# -t   enc. type of key
# -s   size of key
# -l   directory path
# -p   private key location
# -r   public key location
# -x   key expire_date  0,1d,1m,1y
KEY_TYPE="RSA"
KEY_SIZE="2048"
KEY_LOCATION="$HOME/.gnupg"
PUBLIC_KEY_LOCATION="pubring.gpg"
PRIVATE_KEY_LOCATION="secring.gpg"
EXPIREDT="0"
KEYEMAIL="test@example.com"
KEYNAME="test`date +'%Y_%m_%d_T_%H_%M_%S'`"
while getopts ":t:s:l:p:r:x:n:e:n:m:" opt; do
  case $opt in
    t)
      KEY_TYPE="$OPTARG"
      ;;
    s)
      KEY_SIZE="$OPTARG"
      ;;
    l)
      KEY_LOCATION="$OPTARG"
      ;;
    p)
      PUBLIC_KEY_LOCATION="$OPTARG"
      ;;
    r)
      PRIVATE_KEY_LOCATION="$OPTARG"
      ;;
    x)
      EXPIREDT="$OPTARG"
      ;;
    n)
      KEYNAME="$OPTARG"
      ;;
    m)
      KEYEMAIL="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
gpg --homedir "$KEY_LOCATION" --full-generate-key --batch <<EOF
%no-protection
Key-Type: $KEY_TYPE
Key-Length: $KEY_SIZE
Subkey-Type: $KEY_TYPE
Subkey-Length: $KEY_SIZE
Name-Real: $KEYNAME
Name-Email: $KEYEMAIL 
Expire-Date: $EXPIREDT
%commit
EOF
gpg --homedir "$KEY_LOCATION" --export --armor "$KEYNAME" > "$PUBLIC_KEY_LOCATION"
gpg --homedir "$KEY_LOCATION" --export-secret-keys --armor "$KEYNAME" > "$PRIVATE_KEY_LOCATION"
gpg --homedir "$KEY_LOCATION" --list-keys
