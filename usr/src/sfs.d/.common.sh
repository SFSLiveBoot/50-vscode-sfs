#!/bin/sh

: "${lbu:=/opt/LiveBootUtils}"
. "$lbu/scripts/common.func"

: "${dl_url:=https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable}"

: "${pkg_json:=/usr/share/code/resources/app/package.json}"

latest_deb_url() {
  : "${_latest_deb_url:=$(curl -s -I "$dl_url" | sed -ne '/^Location: /{s/.* //;p;q}' | tr -d '\r')}"
  echo "$_latest_deb_url"
}

latest_ver() {
  basename "$(latest_deb_url)" | sed -e 's/^code_\([^_-]\+\)[-_].*/\1/'
}

installed_ver() {
  jq -r .version "$DESTDIR$pkg_json"
}
