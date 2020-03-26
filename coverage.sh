PROJ_OUTPUT=`swift package generate-xcodeproj`;
PROJ_NAME="${PROJ_OUTPUT/generated: .\//}"
SCHEME_NAME="${PROJ_NAME/.xcodeproj/}"

gem install xcpretty > /dev/null

echo "🏗 Building Xcode Scheme: $SCHEME_NAME";

xcodebuild -project $PROJ_NAME -scheme $SCHEME_NAME-Package -configuration Debug -enableCodeCoverage YES test | xcpretty

if [[ $? != 0 ]]; then 
    echo "❌ Xcode Build Failed!";
    exit 1; 
fi

echo "✅ Done!"
