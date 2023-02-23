#!/bin/bash

# Define colors
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
WARNING='\033[0;33m'

# Print the Smart Commit logo
echo -e "${GREEN}\n  ___ __  __   _   ___ _____    ___ ___  __  __ __  __ ___ _____
 / __|  \/  | /_\ | _ \_   _|  / __/ _ \|  \/  |  \/  |_ _|_   _|
 \__ \ |\/| |/ _ \|   / | |   | (_| (_) | |\/| | |\/| || |  | |
 |___/_|  |_/_/ \_\_|_\ |_|    \___\___/|_|  |_|_|  |_|___| |_|
${NC}"


echo -e "\n  Welcome to Smart Commit!\n"
echo "  Author: Sagar Chauhan"
echo -e "  Website: \033[33mhttps://sagarchauhan005.github.io/\033[0m"
echo -e "  Buy me a Coffee: \033[33mhttps://www.buymeacoffee.com/sagarchauhan005\033[0m"
echo "  Version: 0.0.1"
echo "  Description: This tool generates smart TODO comments for Git changes to nudge users to document them before commit."

#LOG_FILE="$(dirname "$0")/smart-commit.log"
# Create log file if it doesn't exist
#touch "$LOG_FILE"
# Redirect standard error to log file
#exec 2>> "$LOG_FILE"

# Check the OS and set package manager
#if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#    # Linux OS detected
#    PKG_MANAGER="apt-get"
#elif [[ "$OSTYPE" == "darwin"* ]]; then
#    # MacOS detected
#    PKG_MANAGER="brew"
#elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
#    # Windows OS detected (using Git Bash)
#    PKG_MANAGER="choco"
#else
#    # Unsupported OS
#    echo "Unsupported operating system."
#    exit 1
#fi
#
## Check for sed and git
#if ! command -v sed > /dev/null; then
#    echo "sed is not installed. Do you want to install sed? (y/n)"
#    read install_sed
#    if [ "$install_sed" == "y" ]; then
#        echo "Installing sed..."
#        sudo $PKG_MANAGER install sed
#        echo "sed installed successfully!"
#    else
#        echo "sed is required to run this script. Exiting..."
#        exit 1
#    fi
#fi
#
#if ! command -v git > /dev/null; then
#    echo "git is not installed. Do you want to install git? (y/n)"
#    read install_git
#    if [ "$install_git" == "y" ]; then
#        echo "Installing git..."
#        sudo $PKG_MANAGER install git
#        echo "git installed successfully!"
#    else
#        echo "git is required to run this script. Exiting..."
#        exit 1
#    fi
#fi


# Loader
echo -e "\n";
spin='-\|/'
for i in $(seq 1 5)
do
  printf "\r ${WARNING} Processing Git changes...${spin:i++%${#spin}:1}"
  sleep 0.1
done
echo -e "\n";
#loader ends

# Define the expected commit message format
COMMIT_FORMAT="^(TEST|FIX|NEW|FEATURE): .+";
# get the list of changed files
files=$(git diff --cached --name-only)
#echo "Files";
#echo $files;

# Keep track of whether any files have a TODO comment
has_todo_comment=false
i=1;
if [ -z "$files" ]
then
    echo -e "${GREEN}  No file changes detected. All good to go ! You can push the changes....${NC}\n";
else
    for file in $files
    do
      supported_file=true;
        # Check file permissions before running sed or git commands
#        if [ ! -w "$file" ]
#        then
#            echo -e "${RED}   - '$file' is not writable. Please check file permissions and try again.${NC}\n"
#        fi

        echo -e "${GREEN}\n ${i}. Changed File :${NC} $file\n"
        i=$(( i + 1 ))
        # get the git diff output for the file and extract the line number where the changes start
        diff_output=$(git diff --cached --unified=0 "$file")
        line_number=$(echo "$diff_output" | grep -E "^@@.*\+[0-9]+.*@@" | cut -d "+" -f 2 | cut -d "," -f 1)
        line_number=$(echo "$line_number" | grep -oE '[0-9]+' | sed -n 1p)
        #extension="${file##*.}"
        #extension=$(echo "$file" | rev | cut -d. -f1,2 | rev | awk '{print tolower($0)}')
        filename=$(basename -- "$file")
        extension=""
        if [[ $filename == *.*.* ]]; then
            extension=$(echo "$filename" | rev | cut -d. -f1,2 | rev | awk '{print tolower($0)}')
        else
            extension=$(echo "$filename" | rev | cut -d. -f1 | rev | awk '{print tolower($0)}')
        fi
#        echo "extension";
#        echo $extension;
        case $extension in
            html)
                todo_comment="\t\t\t<!--TODO: Add more descriptive comment here. Allowed format => FIX|DEBUG|INFO: Your comment -->"
                comment_start="<!--"
                ;;
            css)
                todo_comment="\t/*TODO: Add more descriptive comment here. Allowed format => FIX|DEBUG|INFO: <Your comment> */"
                comment_start="\/\*"
                ;;
            blade.php)
                todo_comment="\t\t\t{{--TODO: Add more descriptive comment here. Allowed format => FIX|DEBUG|INFO: <Your comment> --}}"
                comment_start="{{--"
                ;;
            env)
                todo_comment="#TODO: Add more descriptive comment here. Allowed format => FIX|DEBUG|INFO: <Your comment>"
                comment_start="#"
                ;;
            js|php|py|rb|vue)
                todo_comment="\t\t\t//TODO: Add more descriptive comment here. Allowed format => FIX|DEBUG|INFO: <Your comment>"
                comment_start="\/\/"
                ;;
            *)
                supported_file=false;
                echo -e "${MAGENTA}   - INFO: This file is not supported currently to add auto comments due its nature. Please manage it manually....\n ${NC}"
                continue
                ;;
        esac

        if  $supported_file; then
          # Add the comment
          sed -i "${line_number} {/^\s*${comment_start}\(\(FIX\)\|\(INFO\)\|\(DEBUG\)\)/! {/^\s*${comment_start}\s*TODO:/! s,^,${todo_comment}\n,}}" "$file"

          #check if the line contains a TODO comment
          if [ -n "$(sed -n "${line_number}{/^\s*${comment_start}\s*TODO:/p}" "$file")" ]; then
              has_todo_comment=true
              echo -e "${ORANGE}   - Please document your changes at line number $line_number. Allowed format => FIX|DEBUG|INFO: <Your comment>\n ${NC}"
          else
              # check if the line contains a comment starting with FIX, INFO, or DEBUG
              comment=$(sed -n "${line_number}{/^\s*${comment_start}\s*\(FIX\|INFO\|DEBUG\):/p}" "$file")
              if [ -n "$comment" ]; then
                  echo -e "${GREEN}   - Thanks for documenting your changes...${NC}\n"
              else
                  echo "Please follow this format while documenting your changes, FIX|DEBUG|INFO: <Your comment>"
              fi
          fi
        fi
    done

    # prompt the user to enter a commit message and commit the changes
    if ! $has_todo_comment; then

      # Get the commit message from the current commit
       commit_msg_file=$1
       MESSAGE=$(cat "$commit_msg_file")

      # Check if the commit message matches the expected format
      if ! [[ "$MESSAGE" =~ $COMMIT_FORMAT ]]; then
        echo -e "${RED}\n   Error: Invalid commit message format. Please use the format TEST|FIX|NEW|FEATURE: <Message>.${NC}\n"
        exit 1
      fi

      # Commit the changes with the provided commit message
      echo -e "${GREEN}\n   - All files added and committed to git...${NC}\n"
      git add . && git commit -m "$MESSAGE" --no-verify
    else
        echo -e "${GREEN}   - Please document the updates and then commit again...${NC}\n"
        exit 1;
    fi
fi
