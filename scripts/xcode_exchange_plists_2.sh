#!/bin/sh

set -euo pipefail

# Function to get user input for Xcode paths
ask_for_path() {
  read -rp "Enter the path to $1 (default: $2): " input_path
  if [ -z "$input_path" ]; then
    echo "$2"
  else
    echo "$input_path"
  fi
}

# Ask for confirmation before proceeding
read -rp "Do you want to proceed with updating the Xcode build version? (y/n): " confirmation
if [ "$confirmation" != "y" ]; then
  echo "Exiting script."
  exit 0
fi

# Set the paths to your Old/New Xcodes
OLD_XCODE_DEFAULT="/Applications/Xcode-15.4.0.app"
NEW_XCODE_DEFAULT="/Applications/Xcode-16.0.0.app"

OLD_XCODE=$(ask_for_path "the old Xcode" "$OLD_XCODE_DEFAULT")
NEW_XCODE=$(ask_for_path "the new Xcode" "$NEW_XCODE_DEFAULT")

# Get Old and New Xcode build numbers
OLD_XCODE_BUILD=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${OLD_XCODE}/Contents/Info.plist")
NEW_XCODE_BUILD=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${NEW_XCODE}/Contents/Info.plist")

echo "The Old Xcode build version is $OLD_XCODE_BUILD"
echo "The New Xcode build version is $NEW_XCODE_BUILD"

# Change Old Xcode build version to New Xcode build version
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${NEW_XCODE_BUILD}" "${OLD_XCODE}/Contents/Info.plist"

# Open Old Xcode (system will check build version and cache it)
open "$OLD_XCODE" || true

# Revert Old Xcode's build version
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${OLD_XCODE_BUILD}" "${OLD_XCODE}/Contents/Info.plist"

echo "Xcode build version has been reverted."