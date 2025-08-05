#!/bin/bash
set -euo pipefail

# Amazon ECR OIDC Login Script
# Compatible with devops-cove variable system
# Variables loaded via existing config: .env files, default.env, *.branch.env

# Expected environment variables:
# - AWS_REGION: AWS region for ECR
# - REGISTRY_ORG: AWS Account ID (optional, will be discovered)
# - REGISTRY_HOST: ECR registry host (optional, defaults to AWS format)

AWS_REGION="${AWS_REGION:-${AWS_DEFAULT_REGION:-eu-west-2}}"
REGISTRY_ORG="${REGISTRY_ORG:-}"
REGISTRY_HOST="${REGISTRY_HOST:-}"

# GitHub OIDC token configuration
ACTIONS_ID_TOKEN_REQUEST_TOKEN="${ACTIONS_ID_TOKEN_REQUEST_TOKEN:-}"
ACTIONS_ID_TOKEN_REQUEST_URL="${ACTIONS_ID_TOKEN_REQUEST_URL:-}"

if [[ -z "$ACTIONS_ID_TOKEN_REQUEST_TOKEN" || -z "$ACTIONS_ID_TOKEN_REQUEST_URL" ]]; then
    echo "Error: GitHub Actions OIDC environment not available"
    exit 1
fi

# Configure AWS credentials using OIDC
aws configure set region "$AWS_REGION"

# Get AWS credentials via OIDC
JWT_TOKEN=$(curl -sS -H "Authorization: bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" "$ACTIONS_ID_TOKEN_REQUEST_URL" | jq -r '.value')

if [[ -z "$JWT_TOKEN" || "$JWT_TOKEN" == "null" ]]; then
    echo "Error: Failed to obtain GitHub OIDC token"
    exit 1
fi

# Use AWS STS to assume role via OIDC
ROLE_ARN="${AWS_ROLE_ARN:-}"
if [[ -n "$ROLE_ARN" ]]; then
    echo "Assuming AWS role via OIDC..."
    
    # Get temporary credentials
    STS_RESPONSE=$(aws sts assume-role-with-web-identity \
        --role-arn "$ROLE_ARN" \
        --role-session-name "github-actions-$(date +%s)" \
        --web-identity-token "$JWT_TOKEN" \
        --duration-seconds 3600)
    
    export AWS_ACCESS_KEY_ID=$(echo "$STS_RESPONSE" | jq -r '.Credentials.AccessKeyId')
    export AWS_SECRET_ACCESS_KEY=$(echo "$STS_RESPONSE" | jq -r '.Credentials.SecretAccessKey')
    export AWS_SESSION_TOKEN=$(echo "$STS_RESPONSE" | jq -r '.Credentials.SessionToken')
fi

# Discover AWS Account ID if not provided
if [[ -z "$REGISTRY_ORG" ]]; then
    REGISTRY_ORG=$(aws sts get-caller-identity --query Account --output text)
fi

# Determine ECR registry host
if [[ -z "$REGISTRY_HOST" ]]; then
    REGISTRY_HOST="${REGISTRY_ORG}.dkr.ecr.${AWS_REGION}.amazonaws.com"
fi

# Get ECR authorization token
ECR_TOKEN=$(aws ecr get-login-password --region "$AWS_REGION")

# Authenticate with ECR
echo "$ECR_TOKEN" | docker login "$REGISTRY_HOST" --username AWS --password-stdin

echo "Successfully authenticated with ECR at $REGISTRY_HOST"
echo "::add-mask::$ECR_TOKEN"
echo "REGISTRY_TOKEN=$ECR_TOKEN" >> "$GITHUB_ENV"
echo "AWS_ACCOUNT_ID=$REGISTRY_ORG" >> "$GITHUB_ENV"
echo "REGISTRY_HOST=$REGISTRY_HOST" >> "$GITHUB_ENV"