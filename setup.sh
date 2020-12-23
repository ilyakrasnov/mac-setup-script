#!/usr/bin/env bash
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
  cleanmymac
  docker
  dropbox
  firefox
  google-chrome
  iterm2
  mysqlworkbench
  postman
  private-internet-access
  sourcetree
  sequel-pro
  slack
  spotify
  vivaldi
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
    #prompt "Execute: $exec"
    echo "Execute: $exec"
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
install 'brew install' ${casks[@]}

prompt "Installing secondary packages"
install 'gem install' ${gems[@]}

prompt "Set git defaults"
for config in "${git_configs[@]}"
do
  git config --global ${config}
done


prompt "Cleanup"
brew cleanup

echo "Done!"
