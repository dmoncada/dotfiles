#!/usr/bin/env bash

set -euo pipefail

NAME="$(basename "$0")"

################################################################################
# Menu Bar
################################################################################

echo -n "${NAME}: writing settings for the menu bar ... "

# Autohide.
# defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Don't show AirPlay icon.
# defaults write com.apple.airplay showInMenuBarIfPresent -int 0

# Show percentage next to battery icon.
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

echo "Done!"
echo "Note: changes to your menu bar will be picked up next time you log in."

################################################################################
# Dock
################################################################################

echo -n "${NAME}: writing settings for the dock ... "

# Autohide.
defaults write com.apple.dock autohide -int 1

# Magnification.
defaults write com.apple.dock magnification -int 1

# Change the size of icons.
defaults write com.apple.dock tilesize -int 50
defaults write com.apple.dock largesize -int 80

# Position on screen.
# defaults write com.apple.dock orientation -string "bottom"

# Minimize windows into application icon.
defaults write com.apple.dock minimize-to-application -int 1

# Show indicators for open applications.
defaults write com.apple.dock show-process-indicators -int 1

# Show when making gestures.
defaults write com.apple.dock showAppExposeGestureEnabled -int 1
defaults write com.apple.dock showDesktopGestureEnabled -int 0
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0
defaults write com.apple.dock showMissionControlGestureEnabled -int 1

# Hide recent apps.
defaults write com.apple.dock show-recents -int 0

# Reset.
killall Dock

echo "Done!"

################################################################################
# Keyboard
################################################################################

echo -n "${NAME}: writing settings for the keyboard ... "

# Increase the keyboard repeat rate.
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Allow key repeat in apps like VSCode.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -int 0

echo "Done!"

################################################################################
# Trackpad
################################################################################

echo -n "${NAME}: writing settings for the trackpad ... "

# Drag settings.
defaults write com.apple.AppleMultitouchTrackpad DragLock -int 0
defaults write com.apple.AppleMultitouchTrackpad Dragging -int 0

# Scroll settings.
defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -int 1

# Misc. gestures.
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1 # Tap to click.
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1 # Zoom in or out.
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1 # Right click.
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -int 0 # Rotate.

# 2-finger gestures.
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 0 # Smart zoom.
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0 # Notification center.

# 3-finger gestures.
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1 # Drag files.
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0 # Swipe between full-screen apps.
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0 # Look up & data detectors.
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0 # Mission control.

# 4-finger gestures.
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2 # Swipe between full-screen apps.
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 0 # Launchpad & show desktop.
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2 # Mission control.

# 5-finger gestures.
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 0

echo "Done!"

