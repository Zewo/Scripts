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

echo rvm_autoupdate_flag=0 >> ~/.rvmrc
rvm install 2.2.3  > /dev/null
gem install xcpretty > /dev/null

echo "🏗 Building Xcode Scheme: $SCHEME_NAME";

xcodebuild -project $PROJ_NAME -scheme $SCHEME_NAME-Package -configuration Debug -enableCodeCoverage YES test | xcpretty

if [[ $? != 0 ]]; then 
    echo "❌ Xcode Build Failed!";
    exit 1; 
fi

bash <(curl -s https://codecov.io/bash) -J '$SCHEME_NAME'

echo "✅ Done!"
