#!/bin/bash

applescript_code='
tell application "Xcode"
	set x to path of last item of source documents
	log x
end tell
'

# Run the AppleScript to get the file path
file_path=$(osascript -e "$applescript_code" 2>&1)

# Check if the file path exists
if [ -f "$file_path" ]; then
  # Open the file in VSCode
  code "$file_path"
else
  echo "File does not exist: $file_path"
fi