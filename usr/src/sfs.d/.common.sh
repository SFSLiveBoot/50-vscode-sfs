#!/bin/sh

: "${lbu:=/opt/LiveBootUtils}"
. "$lbu/scripts/common.func"

: "${dl_url:=https://update.code.visualstudio.com/latest/linux-deb-x64/stable}"

: "${pkg_json:=/usr/share/code/resources/app/package.json}"

latest_deb_url() {
  local n
  test -n "$_latest_deb_url" || for n in $(seq 10);do
    _latest_deb_url="$(curl -s -I "${_latest_deb_url:-$dl_url}" | sed -ne '/^Location: /{s/.* //;p;q}' | tr -d '\r')"
    case "$_latest_deb_url" in *.deb) break;; esac
  done
  echo "$_latest_deb_url"
}

latest_ver() {
  basename "$(latest_deb_url)" | sed -e 's/^code_\([^_-]\+\)[-_].*/\1/'
}

installed_ver() {
  jq -r .version "$DESTDIR$pkg_json"
}
