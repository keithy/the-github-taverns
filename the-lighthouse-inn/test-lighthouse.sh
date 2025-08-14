#!/bin/bash

set -euo pipefail

# Test the lighthouse.sh script using flags DO NOT CHECK THIS IN THIS IS JUST TESTS

cd /home/keith/devops-cove/the-github-taverns/the-lighthouse-inn

          # Install and use: #Add commands here to resolve
          curl -fsSL https://mise.jdx.gg/install.sh | sh

# Create test directory under the lighthouse inn
test_dir="testdata" #can test multiple ones if want
mkdir -p "$test_dir"

# Create a dummy .ncl config file
cat <<EOF >"$test_dir/test.ncl"
{
  name = "test_resource",
  type = "github",
  org = "testorg",
  repo = "testrepo",
  ref = "testref"
}
EOF

# Run the lighthouse script in test mode and capture output
TEST_MODE=true TEST_DIR="$test_dir" ./lighthouse.sh 2>&1 | tee test_output.log

# Check if the script ran without errors, but allow missing GITHUB_TOKEN
if grep -q "Lighthouse complete." test_output.log; then
  echo "Lighthouse test ran successfully"
elif grep -q "GITHUB_TOKEN is not available, stop comparing SHA" test_output.log; then
    echo "Lighthouse test ran successfully without GITHUB_TOKEN"
else
  echo "Lighthouse test failed, see test_output.log"
  exit 1
fi