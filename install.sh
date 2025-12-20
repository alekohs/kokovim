#!/usr/bin/env bash
set -e
set -u

VERSION="1.2.6"
APPNAME="nvim"

echo "Select name for the nvim instance:"
echo "1) nvim"
echo "2) kokovim-dev"
echo "3) pick your own"
read -p "Enter selection (1-3): " selection

case $selection in
1) APPNAME="nvim" ;;
2) APPNAME="kokovim-dev" ;;
3)
  read -p "Custom name: " APPNAME
  ;;
*)
  echo "Invalid selection. Exiting."
  exit 1
  ;;
esac

KOKOVIM_DEBUG=false
while [[ $# -gt 0 ]]; do
  case "$1" in
  -d)
    KOKOVIM_DEBUG=true
    shift
    ;;
  *)
    shift
    ;;
  esac
done

if $KOKOVIM_DEBUG; then
  echo "Installing app to ${HOME}/.config/${APPNAME}"
  mkdir -p "${HOME}/.config/${APPNAME}"
  rsync -a ./nvim/ "${HOME}/.config/${APPNAME}/"
  exit 1
fi

rm -rf "${HOME}/Downloads/kokovim-v${VERSION}"
mkdir -p "${HOME}/Downloads/kokovim-v${VERSION}"

echo "Download files"
wget -O "${HOME}/Downloads/kokovim-v${VERSION}.tar.gz" "https://github.com/alekohs/kokovim/archive/refs/tags/v${VERSION}.tar.gz"
tar -xzf "${HOME}/Downloads/kokovim-v${VERSION}.tar.gz" -C "${HOME}/Downloads/kokovim-v${VERSION}" "kokovim-${VERSION}/nvim" --strip-components=1

echo "Installing app to ${HOME}/.config/${APPNAME}"
mkdir -p "${HOME}/.config/${APPNAME}"
rsync -a --remove-source-files "${HOME}/Downloads/kokovim-v${VERSION}/nvim/" "${HOME}/.config/${APPNAME}/"
rm -rf "${HOME}/Downloads/kokovim-v${VERSION}"
