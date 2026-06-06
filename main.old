import os
import sys

from simple_salesforce import Salesforce

# --- Fetch Credentials safely from the Environment ---
INSTANCE_URL = os.environ.get("SF_INSTANCE_URL")
ACCESS_TOKEN = os.environ.get("SF_ACCESS_TOKEN")

# Fallback block to explicitly fail fast if the shell isn't configured
if not INSTANCE_URL or not ACCESS_TOKEN:
    print(
        "❌ Error: Environment variables 'SF_INSTANCE_URL' and 'SF_ACCESS_TOKEN' must be set.",
        file=sys.stderr,
    )
    print(
        "👉 TIP: If using the CLI, run: export SF_ACCESS_TOKEN=$(sf org auth show-access-token --target-org dev-org~ --json | jq -r '.result.accessToken')",
        file=sys.stderr,
    )
    sys.exit(1)

try:
    # --- Initialize the client safely ---
    sf = Salesforce(
        instance_url=INSTANCE_URL,
        session_id=ACCESS_TOKEN,
        username="",  # Explicitly passed blank to allow pure session-id token routing
        version="61.0",  # Pin to a modern platform API version
    )

    print(f"✅ Securely authenticated to Salesforce instance: {INSTANCE_URL}")

    # Optional: Quick sanity verification pass to prove the token is accepted
    limits = sf.restful("limits", method="GET")
    print(
        f"📊 API Budget verified: {limits['DailyApiRequests']['Remaining']} calls remaining."
    )

except Exception as e:
    print(f"❌ Authentication handshake failed: {e}", file=sys.stderr)
    sys.exit(1)
