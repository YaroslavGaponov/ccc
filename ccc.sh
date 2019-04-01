#!/bin/bash

# Author: Yaroslav Gaponov [yaroslav.gaponov@gmail.com]

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_ESC=255}

branch=$(git branch)
status=$(git status)

exec 3>&1

result=$(dialog \
--title "$branch" \
--clear \
--msgbox "$status" 20 60 \
--menu "Type:" 20 60 10  \
  "chore"  "Build process or auxiliary tool changes" \
  "ci" "CI related changes"         \
  "docs" "Documentation only changes" \
  "feat" "A new feature" \
  "fix" "A bug fix" \
  "perf" "A code change that improves performance" \
  "refactor" "A code change that neither fixes a bug or adds a feature" \
  "release" "Create a release commit" \
  "style" "Markup, white-space, formatting, missing semi-colons..." \
  "test" "Adding missing tests" \
--inputbox "Scope. \n\nExample: core, api, deps ..." 20 60  \
--inputbox "Subject. \n\nExample: Implemented new Core feature" 20 60 \
2>&1 1>&3)

return_value=$?
exec 3>&-

clear

case $return_value in
  $DIALOG_OK)    
    read type scope subject <<< $(echo ${result})
    git commit -am "${type}(${scope}): ${subject}";;
  $DIALOG_CANCEL)
    echo "Cancel pressed.";;
  $DIALOG_ESC)
    echo "ESC pressed.";;
esac