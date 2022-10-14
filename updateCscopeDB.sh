#!/bin/bash

ROOT=~/Expensidev

# This finds all the cpp files we care about so that when we rebuild the db it's using an up-to-date list
find "$ROOT" ! -path '*node_modules*' ! -path '*Pods*' ! -path '*vendor*' ! -path '*externalLib*' ! -path '*Mobile-Expensify*' ! -path '*App*' -name '*.cpp' -o ! -path '*node_modules*' ! -path '*Pods*' ! -path '*vendor*' ! -path '*externalLib*' ! -path '*Mobile-Expensify*' ! -path '*App*' -name '*.h' > "$ROOT"/cscope.files

# Moves to where we put cscope.files and rebuilds the db used for tracking refernces
cd "$ROOT" && cscope -bqk
