#!/bin/bash

# https://www.shell-tips.com/mac/defaults/#gsc.tab=0

if [ "$(defaults read com.apple.AppleMultitouchTrackpad Clicking)" != "1" ]; then
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
fi
