#!/usr/bin/env bash
set -e
pulumi login --local
python3 -c "
import pulumi_aws as aws
from pulumi import automation as auto

stack = auto.select_stack(
    stack_name='dev',
    project_name='inline_aws',
    program=lambda: None
)
stack.destroy(on_output=print)
print('Destroyed.')
"
