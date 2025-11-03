#!/bin/bash

# This script is converted from .gemini/commands/release.toml

# Exit immediately if a command exits with a non-zero status.
set -e

echo "🚀 INFO: Starting release process."

# Step 1: Increment version
echo "📈 INFO: Incrementing version in pubspec.yaml..."
current_version=$(grep 'version: ' pubspec.yaml | awk '{print $2}')
base_version=$(echo "$current_version" | cut -d'+' -f1)
build_number=$(echo "$current_version" | cut -d'+' -f2)
new_build_number=$((build_number + 1))
new_version="${base_version}+${new_build_number}"
sed -i '' "s/version: ${current_version}/version: ${new_version}/" pubspec.yaml
echo "const String appVersion = '$new_version';" > lib/generated/version.dart
echo "✅ SUCCESS: Version bumped from ${current_version} to ${new_version}"

# Step 2: Commit changes
echo "📝 INFO: Committing version bump..."
git add pubspec.yaml lib/generated/version.dart
git commit -m "chore(release): bump version to ${new_version}"
echo "✅ SUCCESS: Committed pubspec.yaml with version ${new_version}"

# Step 3: Create tag
echo "🏷️ INFO: Creating git tag..."
git tag "v${new_version}"
echo "✅ SUCCESS: Created git tag v${new_version}"

# Step 4: Push to origin
echo "☁️ INFO: Pushing commits and tags to origin..."
git push origin && git push origin --tags
echo "✅ SUCCESS: Pushed to origin."

# Step 5: Build App Bundle
echo "📦 INFO: Building Android App Bundle..."
flutter build appbundle --release
echo "✅ SUCCESS: App Bundle built."

# Step 6: Open Google Play Console
echo "🌐 INFO: Opening Google Play Console in Google Chrome..."
open -a 'Google Chrome' 'https://play.google.com/console/u/0/developers/7678706771924505759/app/4972955630697428940/tracks/internal-testing'
echo "🎉 SUCCESS: Release process completed."
