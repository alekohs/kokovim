#!/usr/bin/env bash
set -e
set -u

VERSION=""
APPNAME="nvim"
FOLLOW_GIT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
  -n)
    APPNAME="$2"
    shift 2
    ;;
  -v)
    VERSION="$2"
    shift 2
    ;;
  -g)
    FOLLOW_GIT=true
    shift
    ;;
  -h)
    echo "Usage: install.sh [options]"
    echo "  -n <name>    App name (default: nvim)"
    echo "  -v <version> Install specific release version"
    echo "  -g           Follow git main branch instead of a release"
    echo "  -h           Show this help"
    echo ""
    echo "For local-dev install from a cloned repo, use 'make nvim' instead."
    exit 0
    ;;
  *)
    echo "Unknown option: $1. Use -h for help."
    exit 1
    ;;
  esac
done

DOWNLOAD_DIR="${HOME}/Downloads/kokovim-install"
rm -rf "${DOWNLOAD_DIR}"
mkdir -p "${DOWNLOAD_DIR}"

if $FOLLOW_GIT; then
  echo "Cloning latest from main branch..."
  git clone --depth 1 https://github.com/alekohs/kokovim.git "${DOWNLOAD_DIR}/repo"
  echo "Installing app to ${HOME}/.config/${APPNAME}"
  mkdir -p "${HOME}/.config/${APPNAME}"
  rsync -a "${DOWNLOAD_DIR}/repo/nvim/" "${HOME}/.config/${APPNAME}/"
else
  if [ -z "$VERSION" ]; then
    echo "Fetching latest release version..."
    VERSION=$(curl -s https://api.github.com/repos/alekohs/kokovim/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    if [ -z "$VERSION" ]; then
      echo "Failed to fetch latest version. Please specify version with -v flag."
      rm -rf "${DOWNLOAD_DIR}"
      exit 1
    fi
    echo "Latest version: $VERSION"
  fi

  echo "Downloading v${VERSION}..."
  wget -O "${DOWNLOAD_DIR}/kokovim.tar.gz" "https://github.com/alekohs/kokovim/archive/refs/tags/v${VERSION}.tar.gz"
  tar -xzf "${DOWNLOAD_DIR}/kokovim.tar.gz" -C "${DOWNLOAD_DIR}" "kokovim-${VERSION}/nvim" --strip-components=1

  echo "Installing app to ${HOME}/.config/${APPNAME}"
  mkdir -p "${HOME}/.config/${APPNAME}"
  rsync -a "${DOWNLOAD_DIR}/nvim/" "${HOME}/.config/${APPNAME}/"
fi

rm -rf "${DOWNLOAD_DIR}"
