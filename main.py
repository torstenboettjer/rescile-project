from simple_salesforce import Salesforce

# Session management and authentication are handled natively
sf = Salesforce(
    instance_url="https://yourdomain.develop.my.salesforce.com",
    session_id="YOUR_SF_ACCESS_TOKEN_HERE",
)

# 1. Create Inbound Connection via Tooling API
payload = {
    "MasterLabel": "AWS-Zurich-Inbound",
    "DeveloperName": "AWS_Zurich_Inbound",
    "AwsRegion": "eu-central-2",
}

# simple-salesforce handles the base URLs, headers, and json encoding/decoding
result = sf.toolingexecute("sobjects/OauthCustomGateway", method="POST", data=payload)
print(f"Created Connection ID: {result['id']}")

# 2. Delete the Connection later
# sf.toolingexecute(f"sobjects/OauthCustomGateway/{result['id']}", method="DELETE")
