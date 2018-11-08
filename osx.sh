# OS X (Mac OS) Setup

# make in case they aren't already there
mkdir -p "/usr/local/lib"
mkdir -p "/usr/local/bin"

# Check for Homebrew and Install it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install and use latest bash
brew install bash
chsh -s /usr/local/bin/bash

# Install git
brew install git

# Install Brew Cask
echo "Installing brew cask..."
brew install caskroom/cask/brew-cask

# Apps
apps=(
  iterm2
  sublime-text3
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
# echo "installing apps..."
# brew cask install --appdir="/Applications" ${apps[@]}