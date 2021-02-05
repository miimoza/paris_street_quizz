#!/bin/sh
pip install pipenv
pipenv uninstall --all
for line in $(cat .gitignore); do
    rm -rf "$line"
done
