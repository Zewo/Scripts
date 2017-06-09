#!/usr/bin/env bash

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

if [[ $OS == "macOS" ]]; then
	SWIFT="swift"
else
	SWIFT="$HOME/.swiftenv/shims/swift"
fi

echo "💼 Building!";

$SWIFT build

if [[ $? != 0 ]]; then 
    echo "❌ Build Failed!";
    exit 1; 
fi

echo "🚀 Building Release!";

$SWIFT build -c release

if [[ $? != 0 ]]; then 
    echo "❌ Release Build Failed!";
    exit 1; 
fi

echo "🔎 Testing!";

env LD_LIBRARY_PATH='/usr/local/lib:/usr/local/opt/libressl/lib:$LD_LIBRARY_PATH' $SWIFT test

if [[ $? != 0 ]]; then 
    echo "❌ Tests Failed!";
    exit 1; 
fi

UNAME=`uname`;

if [[ $OS != "macOS" ]]; then
	echo "✅ Done!"
    exit 0;
fi

PROJ_OUTPUT=`swift package generate-xcodeproj`;
PROJ_NAME="${PROJ_OUTPUT/generated: .\//}"
SCHEME_NAME="${PROJ_NAME/.xcodeproj/}"

echo "🏗 Building Xcode Scheme: $SCHEME_NAME";

rvm install 2.2.3
gem install xcpretty

WORKING_DIRECTORY=$(PWD) xcodebuild -project $PROJ_NAME -scheme $SCHEME_NAME -sdk macosx10.12 -destination arch=x86_64 -configuration Debug -enableCodeCoverage YES test | xcpretty
bash <(curl -s https://codecov.io/bash)

echo "✅ Done!"
