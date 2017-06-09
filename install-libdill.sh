#!/usr/bin/env bash

eval "$(curl -sL http://sh.zewo.io/install.sh)"

UNAME=`uname`;

if [[ $UNAME == "Darwin" ]]; then
    brew install zewo/tap/libdill
else if [[ $UNAME == "Linux" ]]; then
	if [ "$EUID" -e 0 ] then
		echo "deb [trusted=yes] http://apt.zewo.io ./" | sudo tee -a /etc/apt/sources.list
    	sudo apt-get update
    	sudo apt-get install libdill
	fi
else
    echo "❌ Unsupported Operating System: $UNAME";
    exit 1; 
fi
