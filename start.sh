export SF_INSTANCE_URL=$(sf org display --target-org dev-org~ --json | jq -r '.result.instanceUrl')
export SF_ACCESS_TOKEN=$(sf org auth show-access-token --target-org dev-org~ --json | jq -r '.result.accessToken')

python main.py
