#!/bin/bash

GPG_KEY=$(gpg --list-secret-keys --keyid-format LONG | grep "yuyuvn@mac.com" -B 2 | grep expires | awk -F' ' '{print $2}' | awk -F'/' '{print $2}')

if [[ -z "$GPG_KEY" ]]; then
  cat >gpg_config <<EOF
     %echo Generating a basic OpenPGP key
     %no-ask-passphrase
     %no-protection
     Key-Type: DSA
     Key-Length: 3072
     Name-Real: Clicia Scarlet
     Name-Comment: github pgp key
     Name-Email: yuyuvn@mac.com
     Expire-Date: 0
     %commit
     %echo done
EOF
  GPG_KEY=$(gpg --list-secret-keys --keyid-format LONG | grep "yuyuvn@mac.com" -B 2 | grep expires | awk -F' ' '{print $2}' | awk -F'/' '{print $2}')
  echo "Please import this key to github"
  gpg --armor --export yuyuvn@mac.com
fi

CONFIG=$(cat .gitconfig)
CONFIG="${CONFIG/\$SIGNINGKEY/$GPG_KEY}"

if [[ "$1" == "--dry-run" ]]; then
  echo "$CONFIG"
  echo "> ~/.gitconfig"
else
  echo "$CONFIG" > ~/.gitconfig
fi
