#!/usr/bin/env bash

echo "☕️ Let's do this!";

# Determine OS

UNAME=`uname`;

if [[ $UNAME == "Darwin" ]]; then
    OS="macOS";
elif [[ $UNAME == "Linux" ]]; then
    OS="Linux";
else
    echo "❌ Unsupported Operating System: $UNAME";
    exit 1; 
fi

echo "🖥 Operating System: $OS";

if [[ $OS != "macOS" ]]; then
    if [ "$EUID" -e 0 ] then
        sudo apt-get update
        sudo apt-get install clang-3.6 libicu-dev zewo
        sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100
        sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.6 100
    fi

    echo "🐦 Installing Swift!";

    git clone --depth 1 https://github.com/kylef/swiftenv.git ~/.swiftenv
	export SWIFTENV_ROOT="$HOME/.swiftenv"
	export PATH="$SWIFTENV_ROOT/bin:$SWIFTENV_ROOT/shims:$PATH"

    if [ -f ".swift-version" ] || [ -n "$SWIFT_VERSION" ]; then
      swiftenv install -s
    else
      swiftenv rehash
    fi
fi

echo "📅 `swift --version`";
