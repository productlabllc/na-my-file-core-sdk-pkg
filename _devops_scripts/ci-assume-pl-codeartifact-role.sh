export AWS_PROFILE=${AWS_PROFILE:=""}
export CODEARTIFACT_AWS_PROFILE=pl-codeartifact
export CODEARTIFACT_ACCOUNT_ID=135700256913

if [ -z "$AWS_PROFILE" ]
then
  echo '"AWS_PROFILE" environment variable was not set.\n You must set to a valid aws named profile in ~/.aws/credentials. This might be named <client>_ci_assume_role'
  exit 0
fi

export AWS_ASSUME=$(aws sts assume-role --role-arn arn:aws:iam::${CODEARTIFACT_ACCOUNT_ID}:role/pl-codeartifact-role --role-session-name pl-codeartifact-session --query Credentials --profile ${AWS_PROFILE})
export AWS_ACCESS_KEY_ID=$(echo $AWS_ASSUME | npx json 'AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $AWS_ASSUME | npx json 'SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $AWS_ASSUME | npx json 'SessionToken')

aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile "$CODEARTIFACT_AWS_PROFILE"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile  "$CODEARTIFACT_AWS_PROFILE"
aws configure set aws_session_token "$AWS_SESSION_TOKEN" --profile  "$CODEARTIFACT_AWS_PROFILE"
aws configure set region us-east-1 --profile "$CODEARTIFACT_AWS_PROFILE"

aws codeartifact login --tool npm --repository pl-npm --domain pl-npm --domain-owner "$CODEARTIFACT_ACCOUNT_ID" --namespace @pl --profile "$CODEARTIFACT_AWS_PROFILE"

# export AWS_PROFILE=$PROFILE
# echo $AWS_ACCESS_KEY_ID
# echo $AWS_SECRET_ACCESS_KEY
# echo $AWS_SESSION_TOKEN
