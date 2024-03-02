export PROFILE=${PROFILE:=""}
export SSM_PARAM_BUCKET_NAME=${SSM_PARAM_BUCKET_NAME:=""}
export SSM_PARAM_CLOUDFRONT_DIST_ID=${SSM_PARAM_CLOUDFRONT_DIST_ID:=""}
export BUILD_DIR=${BUILD_DIR:=""}
export STORYBOOK_BUILD_DIR=${STORYBOOK_BUILD_DIR:=""}
#web-bucketname-onetribe-dev
#cloudfront-dist-id-onetribe-dev

if [ -z "$PROFILE" ]
then
  echo '"PROFILE" environment variable was not set.\n You must set to a valid aws named profile in ~/.aws/credentials. This might be named <client>_ci_assume_role'
  exit 0
fi

if [ -z "$SSM_PARAM_BUCKET_NAME" ]
then
  echo '"SSM_PARAM_BUCKET_NAME" environment variable was not set.\n A valid SSM parameter name holding the value for the S3 bucket is needed.'
  exit 0
fi

if [ -z "$SSM_PARAM_CLOUDFRONT_DIST_ID" ]
then
  echo '"SSM_PARAM_CLOUDFRONT_DIST_ID" environment variable was not set.\n A valid SSM parameter name holding the value for the Cloudfront Distribution ID is needed.'
  exit 0
fi

if [ -z "$BUILD_DIR" ]
then
  echo '"BUILD_DIR" environment variable was not set.\n Please provide the local build directory to sync assets to S3.'
  exit 0
fi

if [ -z "$STORYBOOK_BUILD_DIR" ]
then
  echo '"STORYBOOK_BUILD_DIR" environment variable was not set.\n If you would like to deploy a current build of storybook assets, please provide the local build directory of storybook assets to sync assets to S3 /storybook.'
fi

export AWS_PROFILE=$PROFILE
export BUCKET_NAME=$(aws ssm get-parameter --name ${SSM_PARAM_BUCKET_NAME} --profile ${PROFILE} --output text --query Parameter.Value | tr -d " ")
export CLOUDFRONT_DIST_ID=$(aws ssm get-parameter --name ${SSM_PARAM_CLOUDFRONT_DIST_ID} --profile ${PROFILE} --output text --query Parameter.Value | tr -d " ")
aws s3 sync ./"$BUILD_DIR"/ s3://"$BUCKET_NAME"/ --acl public-read --profile "$PROFILE"

if [ !-z "$STORYBOOK_BUILD_DIR" ]
then
  aws s3 sync ./storybook-static/ s3://"$BUCKET_NAME"/storybook --acl public-read
fi
aws cloudfront create-invalidation --distribution-id "$CLOUDFRONT_DIST_ID" --paths "/*" --profile "$PROFILE"