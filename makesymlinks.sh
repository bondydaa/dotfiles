#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

# dotfiles directory
dir=~/Code/dotfiles

# list of files to symlink in homedir
files="bash_profile bashrc gitconfig aliases git-completion.bash ackrc inputrc"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
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

#printf '\e[1;34m%-6s\e[m' "Creating symlink to ctag defaults"
#ln -s $dir/default.ctag ~/.ctags.d/default.ctags
