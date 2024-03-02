#!/usr/bin/env node
import { exec } from 'child_process';
import minimist from 'minimist';
import { awsAccountMap } from './config';

const args = minimist(process.argv.slice(2));
const account = awsAccountMap[args.profile];
if (!account) {
  throw new Error(`Must provide valid aws account reference.`);
}

type AwsCredentialsResult = {
  Credentials: {
    AccessKeyId: string,
    SecretAccessKey: string,
    SessionToken: string,
    Expiration: string,
  },
  AssumedRoleUser: {
    AssumedRoleId: string,
    Arn: string,
  },
};

const execAsync = (cmd: string) => new Promise<string>((resolve, reject) => {
  exec(cmd, (err, stdout, stderr) => {
    if (err) {
      reject(err);
    } else if (stderr) {
      reject(stderr);
    } else {
      resolve(stdout);
    }
  });
});

const cmdAssumeRole = `aws sts assume-role --role-arn arn:aws:iam::${account}:role/pl-ci-svc --role-session-name pl-core-ci-svc`;
execAsync(cmdAssumeRole)
  .then(result => JSON.parse(result) as AwsCredentialsResult)
  .then(async ({ AssumedRoleUser, Credentials }: AwsCredentialsResult) => {
    // console.log(JSON.stringify(Credentials));
    console.log(JSON.stringify(args));
    const profile = args.profile || 'default';
    const cmdAwsConfigure = [
      `aws configure set aws_access_key_id ${Credentials.AccessKeyId} --profile ${profile}`,
      `aws configure set aws_secret_access_key ${Credentials.SecretAccessKey} --profile  ${profile}`,
      `aws configure set aws_session_token ${Credentials.SessionToken} --profile  ${profile}`,
      `aws configure set region us-east-1 --profile ${profile}`,
    ];
    for (let i=0; i<cmdAwsConfigure.length; i++) {
      await execAsync(cmdAwsConfigure[i]);
    }
  })
  .catch((err) => {
    console.error(err.message);
  });