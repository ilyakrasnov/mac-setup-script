#!/usr/bin/env bash

# Mac Apps
apps=(
  deckset
  ulysses
  bettersnaptool
)

brews=(
  coreutils
  dfc
  findutils
  git
  htop
  macvim
  mutt
  node
  postgresql
  pgcli
  python
  python3
  tmux
  tree
  trash
  vim
  zsh
  zsh-completions
)

casks=(
  1password
  alfred
  anaconda
  caffeine
  cleanmymac
  docker
  dropbox
  firefox
  flux
  google-chrome
  iterm2
  moneymoney
  postman
  private-internet-access
  sourcetree
  skype
  slack
  spotify
  vlc
  webstorm
)

gems=(
  bundle
)

git_configs=(
  "user.name ilyakrasnov"
  "user.email ilya.krasnov@gmail.com"
)

######################################## End of app list ########################################
set +e
set -x

function prompt {
  read -p "Hit Enter to $1 ..."
}

if test ! $(which brew); then
  prompt "Install Xcode"
  xcode-select --install

  prompt "Install Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  prompt "Update Homebrew"
  brew update
  brew upgrade
fi
brew doctor
brew tap homebrew/dupes

function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    prompt "Execute: $exec"
    if ${exec} ; then
      echo "Installed $pkg"
    else
      echo "Failed to execute: $exec"
    fi
  done
}

prompt "Install packages"
brew info ${brews[@]}
install 'brew install' ${brews[@]}

prompt "Install software"
brew tap caskroom/versions
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}

prompt "Installing secondary packages"
install 'gem install' ${gems[@]}

prompt "Set git defaults"
for config in "${git_configs[@]}"
do
  git config --global ${config}
done

#prompt "Install mac CLI [NOTE: Say NO to bash-completions since we have fzf]!"
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

#prompt "Update packages"
#pip3 install --upgrade pip setuptools wheel
#mac update

prompt "Cleanup"
brew cleanup
brew cask cleanup

#read -p "Run `mackup restore` after DropBox has done syncing ..."
echo "Done!"
