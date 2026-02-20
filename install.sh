#!/usr/bin/env bash
set -e
set -u

VERSION=""
APPNAME="nvim"

# Parse command line arguments
KOKOVIM_DEBUG=false
while [[ $# -gt 0 ]]; do
  case "$1" in
  -d)
    KOKOVIM_DEBUG=true
    shift
    ;;
  -v)
    VERSION="$2"
    shift 2
    ;;
  *)
    shift
    ;;
  esac
done

# Fetch latest release version if not specified
if [ -z "$VERSION" ]; then
  echo "Fetching latest release version..."
  VERSION=$(curl -s https://api.github.com/repos/alekohs/kokovim/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  if [ -z "$VERSION" ]; then
    echo "Failed to fetch latest version. Please specify version with -v flag."
    exit 1
  fi
  echo "Latest version: $VERSION"
fi

# Use whiptail for app name selection
if command -v whiptail &>/dev/null; then
  CHOICE=$(whiptail --title "Kokovim Installation" --menu "Select name for the nvim instance:" 15 60 4 \
    "1" "nvim" \
    "2" "kokovim-dev" \
    "3" "Custom name" 3>&1 1>&2 2>&3)

  case $CHOICE in
  1) APPNAME="nvim" ;;
  2) APPNAME="kokovim-dev" ;;
  3)
    APPNAME=$(whiptail --inputbox "Enter custom name:" 8 60 "kokovim" --title "Custom App Name" 3>&1 1>&2 2>&3)
    if [ -z "$APPNAME" ]; then
      echo "No name provided. Exiting."
      exit 1
    fi
    ;;
  *)
    echo "No selection made. Exiting."
    exit 1
    ;;
  esac
else
  # Fallback to simple read if whiptail is not available
  echo "Select name for the nvim instance:"
  echo "1) nvim"
  echo "2) kokovim-dev"
  echo "3) pick your own"
  read -p "Enter selection (1-3): " selection -r

  case $selection in
  1) APPNAME="nvim" ;;
  2) APPNAME="kokovim-dev" ;;
  3)
    read -p "Custom name: " APPNAME -r
    ;;
  *)
    echo "Invalid selection. Exiting."
    exit 1
    ;;
  esac
fi

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
