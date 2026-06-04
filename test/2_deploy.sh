#!/usr/bin/env bash
set -e

# Force Pulumi to look at the local filesystem backend instead of the cloud SaaS
pulumi login --local

python3 -c "
import pulumi
from pulumi import automation as auto
import pulumi_aws as aws

def pulumi_program():
    bucket_names = ['web-prod', 'web-stage']
    buckets = [
        aws.s3.Bucket(name, tags={'Name': name})
        for name in bucket_names
    ]
    pulumi.export('last_bucket_name', buckets[-1].bucket)

project_name = 'inline_aws'
stack_name = 'dev'

print('Initializing stack...')
stack = auto.create_or_select_stack(
    stack_name=stack_name,
    project_name=project_name,
    program=pulumi_program
)

print('Setting AWS region...')
stack.set_config('aws:region', auto.ConfigValue(value='eu-central-2'))

print('Running pulumi up...')
up_res = stack.up(on_output=print)
"
