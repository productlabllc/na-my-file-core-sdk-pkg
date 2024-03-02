export AWS_PAGER=""
export DEPLOYMENT_TARGET=${DEPLOYMENT_TARGET:='dev'}
export GIT_COMMIT=${GIT_COMMIT:=$(git log --format="%H" -n1 | head -c 7)}
export GIT_BRANCH=${GIT_BRANCH:=$(git branch --show-current)}
export AWS_DEFAULT_REGION=us-east-1
export AWS_PROFILE=onetribe
export AWS_ACCOUNT=$(aws sts get-caller-identity --query 'Account')
export APP_VERSION=$(echo "console.log(require('./package.json').version)" | node)
export APP_NAME="OneTribe.UI"
export APP_DESCRIPTION="Main UI for OneTribe platform."
export ORG_NAME="OneTribe"
export ORG_NAME_ABBV="OneTribe"
export BUSINESS_UNIT="Platform Technology"
export TECHNICAL_CONTACT=wes@productlab.dev
# export NODE_TLS_REJECT_UNAUTHORIZED=0

# Target AWS Account
# This will override the account to deploy to on any standard branch build default targets (i.e. dev, stage, uat, master)
# export AWS_DEPLOY_ACCOUNT_OVERRIDE=some-specific-aws-account

# Build from feature branch
export FEATURE_BRANCH_BUILD_PATTERN="^JIRA-[0-9]{3,4}.*"
export FEATURE_BRANCH_BUILD_AWS_DEPLOY_ACCOUNT=specific-aws-account-to-deploy-feature-branch
