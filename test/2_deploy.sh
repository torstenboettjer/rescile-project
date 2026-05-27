#!/usr/bin/env bash
set -e

# Force Pulumi to look at the local filesystem backend instead of the cloud SaaS
pulumi login --local

python3 -c "
import pulumi
from pulumi import automation as auto
import pulumi_aws as aws

def pulumi_program():
    server_names = ['web-prod', 'web-stage']
    for name in server_names:
        server = aws.ec2.Instance(
            name,
            instance_type='t3.micro',
            ami='ami-0c55b159cbfafe1f0',
            tags={'Name': name}
        )
    pulumi.export('last_server_id', server.id)

project_name = 'inline_aws'
stack_name = 'dev'

print('Initializing stack...')
stack = auto.create_or_select_stack(
    stack_name=stack_name,
    project_name=project_name,
    program=pulumi_program
)

print('Setting AWS region...')
stack.set_config('aws:region', auto.config.Value(value='eu-central-1'))

print('Running pulumi up...')
up_res = stack.up(on_output=print)
"
