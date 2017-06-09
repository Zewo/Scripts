#!/usr/bin/env bash

echo "☕️ Let's do this!";

# Determine OS

UNAME=`uname`;

if [[ $UNAME == "Darwin" ]]; then
    OS="macOS";
else if [[ $UNAME == "Linux" ]]; then
    OS="Linux";
else
    echo "❌ Unsupported Operating System: $UNAME";
    exit 1; 
fi

echo "🖥 Operating System: $OS";

if [[ $OS != "macOS" ]]; then
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
