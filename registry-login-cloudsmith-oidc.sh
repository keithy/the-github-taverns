#!/bin/bash
set -euo pipefail

# Cloudsmith OIDC Login Script
# Compatible with devops-cove pipeline variable system
# Variables loaded via existing config: .env files, default.env, *.branch.env

# Expected environment variables:
# - REGISTRY_ORG: Cloudsmith organization/account name
# - OIDC_SERVICE_SLUG: Cloudsmith OIDC service slug
# - REGISTRY_HOST: Cloudsmith registry host (supports custom domains)

# Use existing variable resolution pattern
REGISTRY_ORG="${REGISTRY_ORG:-${CLOUDSMITH_ORG-}}"
OIDC_SERVICE_SLUG="${OIDC_SERVICE_SLUG:-${CLOUDSMITH_SERVICE_SLUG:-}}"
REGISTRY_HOST="${REGISTRY_HOST:-${CLOUDSMITH_HOST:-docker.cloudsmith.io}}"

# Required variables check
if [[ -z "${REGISTRY_ORG:-}" ]]; then
    echo "Error: REGISTRY_ORG (or CLOUDSMITH_ORG) must be set in your config"
    exit 1
fi

if [[ -z "${OIDC_SERVICE_SLUG:-}" ]]; then
    echo "Error: OIDC_SERVICE_SLUG (or CLOUDSMITH_SERVICE_SLUG) must be set in your config"
    exit 1
fi

# GitHub OIDC token exchange
ACTIONS_ID_TOKEN_REQUEST_TOKEN="${ACTIONS_ID_TOKEN_REQUEST_TOKEN:-}"
ACTIONS_ID_TOKEN_REQUEST_URL="${ACTIONS_ID_TOKEN_REQUEST_URL:-}"

if [[ -z "$ACTIONS_ID_TOKEN_REQUEST_TOKEN" || -z "$ACTIONS_ID_TOKEN_REQUEST_URL" ]]; then
    echo "Error: GitHub Actions OIDC environment not available, (set permissions id-token: write)"
    exit 1
fi

JWT_TOKEN=$(curl -sS -H "Authorization: bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" "$ACTIONS_ID_TOKEN_REQUEST_URL" | jq -r '.value')

if [[ -z "$JWT_TOKEN" || "$JWT_TOKEN" == "null" ]]; then
    echo "Error: Failed to obtain GitHub OIDC token"
    exit 1
fi

# Exchange for Cloudsmith token
CLOUDSMITH_TOKEN=$(curl -sS -X POST "https://api.cloudsmith.io/openid/${REGISTRY_ORG}/${OIDC_SERVICE_SLUG}/" \
    -H "Content-Type: application/json" \
    -d "{\"token\":\"$JWT_TOKEN\"}" \
    | jq -r '.token')

if [[ -z "$CLOUDSMITH_TOKEN" || "$CLOUDSMITH_TOKEN" == "null" ]]; then
    echo "Error: Failed to exchange OIDC token for Cloudsmith token"
    exit 1
fi

# Authenticate with Cloudsmith
echo "$CLOUDSMITH_TOKEN" | docker login $REGISTRY_HOST -u token --password-stdin

echo "Successfully authenticated with Cloudsmith at $REGISTRY_HOST"
echo "::add-mask::$CLOUDSMITH_TOKEN"
echo "REGISTRY_TOKEN=$CLOUDSMITH_TOKEN" >> "$GITHUB_ENV"
echo "CLOUDSMITH_API_KEY=$CLOUDSMITH_TOKEN" >> "$GITHUB_ENV"