#!/bin/bash

export PROFILE=${PROFILE:=""}
export ASSUME_ROLE_PROFILE_NAME=${ASSUME_ROLE_PROFILE_NAME:=""}

if [ -z "$PROFILE" ]
then
  echo '"PROFILE" environment variable was not set.\n You must set to a valid aws named profile in ~/.aws/credentials. This might be named <client>_ci_assume_role'
  exit 0
fi

if [ -z "$ASSUME_ROLE_PROFILE_NAME" ]
then
  echo '"ASSUME_ROLE_PROFILE_NAME" environment variable was not set.\n Set this to anything you wish, such as, <client>_session_profile'
  exit 0
fi

export ACCT_ID=$(aws sts get-caller-identity --query 'Account' --output text --profile ${PROFILE})
export AWS_ASSUME=$(aws sts assume-role --role-arn "arn:aws:iam::${ACCT_ID}:role/ci-svc-role" --query Credentials --role-session-name onetribe-ci-session --profile ${PROFILE})
export AWS_ACCESS_KEY_ID=$(echo $AWS_ASSUME | npx json 'AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $AWS_ASSUME | npx json 'SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $AWS_ASSUME | npx json 'SessionToken')

aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile "$ASSUME_ROLE_PROFILE_NAME"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile  "$ASSUME_ROLE_PROFILE_NAME"
aws configure set aws_session_token "$AWS_SESSION_TOKEN" --profile  "$ASSUME_ROLE_PROFILE_NAME"
aws configure set region us-east-1 --profile "$ASSUME_ROLE_PROFILE_NAME"

export AWS_PROFILE=$ASSUME_ROLE_PROFILE_NAME

echo "AWS profile '$ASSUME_ROLE_PROFILE_NAME' saved with session token."

# echo $ACCT_ID
# echo $AWS_ACCESS_KEY_ID
# echo $AWS_SECRET_ACCESS_KEY
# echo $AWS_SESSION_TOKEN
