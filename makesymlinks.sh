#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

# dotfiles directory
dir=~/code/dotfiles

# list of files to symlink in homedir
files="bash_profile bashrc gitconfig aliases ackrc inputrc"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# cleanup existing files, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
printf '\e[1;34m%-6s\e[m' "Removing existing dotfiles"
printf "\n"
for file in $files
do
    rm ~/.$file
done

#printf '\e[1;34m%-6s\e[m' "Removing ctag defaults"
#rm ~/.ctags.d/default.ctags

printf '\e[1;34m%-6s\e[m' "Creating symlink to files in home directory"
printf "\n"
for file in $files
do
    printf "ln -s $dir/$file  ~/.$file\n"
    ln -s $dir/$file ~/.$file
done

# rinse and repeat for configuration files in ~/.config
dir=~/code/dotfiles/nvim/
files="init.lua"

echo -n "Changing to the $dir directory ..."
cd $dir

echo -n "Ensure ~/.config/nvim directory exists ..."
mkdir -p ~/.config/nvim

printf '\e[1;34m%-6s\e[m' "Creating symlink to files in home directory"
printf "\n"
for file in $files
do
    printf "ln -snf $dir/$file  ~/.config/nvim/$file\n"
    ln -snf $dir/$file ~/.config/nvim/$file
done
