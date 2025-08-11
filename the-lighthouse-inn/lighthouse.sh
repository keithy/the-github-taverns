#!/bin/bash

# This script will:
# 1. Find all projects with external resource definitions (e.g., *.ncl files).
# 2. Combine the configurations into a single config.
# 3. Check for updates to the external resources.
# 4. If updates are found, trigger the watchman-linus workflow.

set -euo pipefail

# Find all projects with external resource definitions.
NICKEL_FILES=$(find . -name "*.ncl")

# Combine the configurations into a single config.
echo "Combining configurations..."
COMBINED_CONFIG="/tmp/external-resources.ncl"
find . -name "*.ncl" -print0 | sort -z | xargs -0 cat > $COMBINED_CONFIG
mise run nickel format $COMBINED_CONFIG

# Check for updates to the external resources.
echo "Checking for updates..."

# Evaluate the combined Nickel configuration
RESOURCES=$(mise run nickel eval $COMBINED_CONFIG | jq .)

# Read cache
CACHE_KEY=$(sha256sum $COMBINED_CONFIG | awk '{print $1}')
CACHE_PATH="/tmp/lighthouse-cache"

mkdir -p "$(dirname \"$CACHE_PATH\")"

if [[ -f "$CACHE_PATH" ]]; then
  echo "Cache file exists, reading..."
  OLD_RESOURCES=$(cat "$CACHE_PATH")
else
  echo "Cache file doesn't exist"
  OLD_RESOURCES='{}'
fi

#Compare SHA
Sha_changed=false
if [ -n "$GITHUB_TOKEN" ]; then
  echo "GITHUB_TOKEN is available, start comparing SHA"
else
  echo "GITHUB_TOKEN is not available, stop comparing SHA"
  exit 1
fi

NEW_RESOURCES=$(echo $RESOURCES | jq -c '.[]' | \
  while read -r RESOURCE; do

  RESOURCE_NAME=$(echo "$RESOURCE" | jq -r .name)
  RESOURCE_TYPE=$(echo "$RESOURCE" | jq -r .type)
  RESOURCE_ORG=$(echo "$RESOURCE" | jq -r .org)
  RESOURCE_REPO=$(echo "$RESOURCE" | jq -r .repo)
  RESOURCE_REF=$(echo "$RESOURCE" | jq -r .ref)
  OLD_RESOURCE_SHA=$(echo "$OLD_RESOURCES" | jq -r --arg name "$RESOURCE_NAME" '.[$name]' 2>/dev/null)

    if [ "$RESOURCE_TYPE" == "github" ]; then
        echo "This is a github repo"
        NEW_RESOURCE_SHA=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN"  "https://api.github.com/repos/$RESOURCE_ORG/$RESOURCE_REPO/commits/$RESOURCE_REF" -H "Accept: application/vnd.github+json" | jq .sha)

          if [ "$NEW_RESOURCE_SHA" ==  "$OLD_RESOURCE_SHA" ]; then
            echo "Sha didn't change"
          else
            echo "Sha changed from $OLD_RESOURCE_SHA to $NEW_RESOURCE_SHA"
            Sha_changed=true
          fi

    fi
  echo "{\"$RESOURCE_NAME\": \"$NEW_RESOURCE_SHA\"}"
done  | jq -s add )                #Merge all JSON

# If any resources have changed, update the cached values and trigger watchman-linus.
if [ "$Sha_changed" = "true" ]; then
  echo "External resources have changed. Triggering watchman-linus..."
  gh workflow run watchman-linus.hm.yml
  echo "$NEW_RESOURCES" > $CACHE_PATH
elseecho "No external resources have changed."
fi

echo "Lighthouse complete."