#!/bin/bash

if [[ `hostname` =~ 'database' ]]; then
  echo "You probably wanted to run this on the "
  echo "infrastructure host, not the database host."
  echo ""
  echo "    # At a new terminal"
  echo "    cd m310-vagrant-env"
  echo "    vagrant up"
  echo "    vagrant ssh infrastructure"
  exit 1
fi

sudo pip install PyKMIP==0.4.0
