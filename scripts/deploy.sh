#!/bin/bash
set -e

ENVIRONMENT="${1:-preview-$(whoami)}"

if [[ "$ENVIRONMENT" != "prod" ]]; then
    export overrideWarningsEnabled=false
fi

echo "Starting AWS CDK deployment to environment: $ENVIRONMENT"

if ! aws sts get-caller-identity --profile work > /dev/null 2>&1; then
    echo "AWS CLI not configured. Run 'aws configure' first."
    exit 1
fi

echo "Building frontend..."
pnpm --filter nextjsapp run build

echo "Installing CDK dependencies..."
cd packages/cdk
pnpm install
pnpm run build

echo "Bootstrapping CDK..."
npx cdk bootstrap --profile work --progress events

echo "Deploying CDK stacks for environment: $ENVIRONMENT..."

DEPLOY_CMD=(npx cdk deploy --all --context "environment=$ENVIRONMENT" --require-approval never --progress events --profile work)

if [[ "$ENVIRONMENT" == "preview-"* ]]; then
    echo "Using hotswap deployment for faster development feedback..."
    DEPLOY_CMD+=(--hotswap-fallback)
else
    echo "Using standard deployment for shared environment..."
fi

"${DEPLOY_CMD[@]}"

echo ""
echo "Retrieving deployment information..."

FRONTEND_URL=$(aws cloudformation describe-stacks \
    --stack-name "NextJSAppFrontend-${ENVIRONMENT}" \
    --query 'Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue' \
    --output text \
    --profile work 2>/dev/null || echo "Not available yet")

DISTRIBUTION_ID=$(aws cloudformation describe-stacks \
    --stack-name "NextJSAppFrontend-${ENVIRONMENT}" \
    --query 'Stacks[0].Outputs[?OutputKey==`DistributionId`].OutputValue' \
    --output text \
    --profile work 2>/dev/null || echo "Not available yet")

echo ""
echo "Deployment complete for environment: $ENVIRONMENT!"
if [ "$FRONTEND_URL" != "Not available yet" ]; then
    echo "Frontend URL: $FRONTEND_URL"
else
    echo "Frontend URL: Check CloudFormation console for outputs"
fi
echo ""
echo "Usage examples:"
echo "  ./scripts/deploy.sh                   # Deploy to preview-\$(whoami)"
echo "  ./scripts/deploy.sh dev               # Deploy to dev"
echo "  ./scripts/deploy.sh prod              # Deploy to production"
