# Install Cscope
1. Go here [https://cscope.sourceforge.net/](https://cscope.sourceforge.net/) to the Downloads section and download, un-archive (`tar -xf cscope-15.9.tar.gz`)
1. `cd` into the scope directory that was just unarchived.
1. run `./configure && make`, run `sudo make install`
1. refresh yourself here [https://cscope.sourceforge.net/cscope_vim_tutorial.html](https://cscope.sourceforge.net/cscope_vim_tutorial.html) **Note** I couldn't get the key mappings to load auto-magically when they were in the ~/.vim/ directory even though that is in my `runtimepath` so even though I'm using vim v6+ (I believe 9.xx) I just added to my vimrc to import the `cscope_maps.vim` file

# Building reference db for cpp code
1. cd into Expensidev
1. `find ~/Expensidev ! -path '*node_modules*' ! -path '*Pods*' ! -path '*vendor*' ! -path '*externalLib*' ! -path '*Mobile-Expensify*' ! -path '*App*' -name '*.cpp' -o ! -path '*node_modules*' ! -path '*Pods*' ! -path '*vendor*' ! -path '*externalLib*' ! -path '*Mobile-Expensify*' ! -path '*App*' -name '*.h' > cscope.files`
1. run `cscope -b -q -k`
1. set the `CSCOPE_DB` environment variable in your shell profile (for bash `export CSCOPE_DB=/Users/dbondy/Expensidev/cscope.out`)

# Automatically rebuild reference db
1. there is the script `updateCscopeDB.sh` which can be run manually or put into a githook file (still to be tested) so that this will run whenever we pull/merge code
