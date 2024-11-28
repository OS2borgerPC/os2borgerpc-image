#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
  echo "Critical error. Halting registration: This program must be run as root"
  exit 1
fi

# default fallback os2borgerpc-client if no value is configured.
DEFAULT_OS2BORGERPC_CLIENT=https://github.com/OS2borgerPC/os2borgerpc-client.git

# Install the configured os2borgerpc-client if it's not already installed
if ! pip show os2borgerpc-client > /dev/null 2>&1; then
  echo "OS2borgerPC-client is not installed. Installing now..."

  # Load values from the config file
  CONFIG_FILE="/etc/os2borgerpc/os2borgerpc.conf"
  PACKAGE_NAME=$(grep "^os2borgerpc_client_package:" "$CONFIG_FILE" | cut -d':' -f2- | xargs)

  if [ -z "$PACKAGE_NAME" ]; then
    echo "No client package specified. Defaulting to $DEFAULT_OS2BORGERPC_CLIENT"
    PACKAGE_NAME="$DEFAULT_OS2BORGERPC_CLIENT"
  fi

  # Check if PACKAGE_NAME is a GitHub URL or a PyPI package name
  if [[ "$PACKAGE_NAME" == https://github.com/* ]]; then
      # Parse GitHub username and repository name
      GITHUB_USER=$(echo "$PACKAGE_NAME" | awk -F'/' '{print $(NF-1)}')
      REPO_NAME=$(echo "$PACKAGE_NAME" | awk -F'/' '{print $NF}' | sed 's/.git$//')

      # Fetch the latest tag from the GitHub API
      LATEST_TAG=$(curl -s "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME/tags" | jq -r '.[0].name')

      # Check if a tag was found and install from GitHub
      if [ -z "$LATEST_TAG" ]; then
          echo "No tags found for GitHub repository $GITHUB_USER/$REPO_NAME"
          exit 1
      else
          echo "Latest GitHub tag for $REPO_NAME: $LATEST_TAG"
          echo "Installing package from GitHub..."
          pip install "git+$PACKAGE_NAME@$LATEST_TAG" > /dev/null

          # Set values in config file
          set_os2borgerpc_config os2borgerpc_client_package "$PACKAGE_NAME"
          set_os2borgerpc_config os2borgerpc_client_version "$LATEST_TAG"
      fi
  else
      # Assume PACKAGE_NAME is a PyPI package name and fetch the latest version from PyPI
      LATEST_VERSION=$(curl -s "https://pypi.org/pypi/$PACKAGE_NAME/json" | jq -r '.info.version')
      echo "https://pypi.org/pypi/$PACKAGE_NAME/json | jq -r '.info.version'"

      # Check if a version was found and install from PyPI
      if [ -z "$LATEST_VERSION" ]; then
          echo "No version found for PyPI package $PACKAGE_NAME"
          exit 1
      else
          echo "Latest PyPI version for $PACKAGE_NAME: $LATEST_VERSION"
          echo "Installing package from PyPI..."
          pip install "$PACKAGE_NAME==$LATEST_VERSION" > /dev/null

          # Set values in config file
          set_os2borgerpc_config os2borgerpc_client_package "$PACKAGE_NAME"
          set_os2borgerpc_config os2borgerpc_client_version "$LATEST_VERSION"
      fi
  fi
fi

/usr/local/bin/register_new_os2borgerpc_client.sh
