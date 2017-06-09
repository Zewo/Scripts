#!/usr/bin/env bash

echo "☕️ Let's do this!";

# Set default Swift version

SWIFT_VERSION="${SWIFT_VERSION:-3.1}"

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
    if ! hash clang 2> /dev/null; then
        sudo apt-get update
        sudo apt-get install clang-3.6 libicu-dev
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
