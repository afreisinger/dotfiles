#!/bin/bash

# Check the current version of npm
current_version=$(npm --version)
echo "Current npm version: $current_version"

# Get the latest available version of npm
latest_version=$(npm show npm version)
echo "Latest npm version available: $latest_version"

# Check if npm is outdated
if [[ "$current_version" != "$latest_version" ]]; then
  echo "npm is outdated. Updating..."
  npm install -g npm
  echo "npm update completed."
else
  echo "npm is up to date. No update is required."
fi
