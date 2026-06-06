# run first to generate credentials: sf org login web --alias dev-org
# show the access token: sf org auth show-access-token --target-org dev-org~

import json
import subprocess
import sys

from simple_salesforce import Salesforce

TARGET_ALIAS = "dev-org~"

try:
    # 1. Fetch the metadata (Instance URL) from org display
    display_output = subprocess.check_output(
        ["sf", "org", "display", "--target-org", TARGET_ALIAS, "--json"],
        stderr=subprocess.DEVNULL,
    )
    display_data = json.loads(display_output)["result"]
    SF_INSTANCE_URL = display_data["instanceUrl"]

    # 2. Fetch the unmasked access token from auth show-access-token
    auth_output = subprocess.check_output(
        [
            "sf",
            "org",
            "auth",
            "show-access-token",
            "--target-org",
            TARGET_ALIAS,
            "--json",
        ],
        stderr=subprocess.DEVNULL,
    )
    auth_data = json.loads(auth_output)["result"]
    SF_ACCESS_TOKEN = auth_data["accessToken"]

except (subprocess.CalledProcessError, FileNotFoundError, KeyError) as e:
    print(f"❌ Error extracting CLI data for '{TARGET_ALIAS}': {e}", file=sys.stderr)
    print("👉 Ensure you are authenticated in 'sf org list'", file=sys.stderr)
    sys.exit(1)

print(f"🔄 Handshaking with endpoint: {SF_INSTANCE_URL}")

# 3. Initialize the simple-salesforce client
sf = Salesforce(
    instance_url=SF_INSTANCE_URL, session_id=SF_ACCESS_TOKEN, version="61.0"
)

# 4. Verify control plane access via live API call
limits = sf.restful("limits", method="GET")
print(f"📊 Success! Connected to Salesforce API.")
print(
    f"   Budget Remaining: {limits['DailyApiRequests']['Remaining']} calls left today."
)
