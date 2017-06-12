#!/usr/bin/env bash

eval "$(curl -sL http://sh.zewo.io/install.sh)"

UNAME=`uname`;

echo "🔥 Installing Zewo";

if [[ $UNAME == "Darwin" ]]; then
    brew install zewo/tap/zewo
elif [[ $UNAME == "Linux" ]]; then
	if [ $(dpkg-query -W -f='${Status}' libdill 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		echo "deb [trusted=yes] http://apt.zewo.io ./" | sudo tee -a /etc/apt/sources.list
		sudo apt-get update
		sudo apt-get install zewo
	fi
else
    echo "❌ Unsupported Operating System: $UNAME";
    exit 1; 
fi

if [[ $? != 0 ]]; then 
    echo "❌ Install Failed!";
    exit 1; 
else
	echo "💥 Succesfully installed Zewo";
fi
