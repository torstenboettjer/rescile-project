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
    sys.exit(1)

# --- Initialize the client safely ---
sf = Salesforce(
    instance_url=INSTANCE_URL,
    session_id=ACCESS_TOKEN,
)

print(f"✅ Securely authenticated to Salesforce instance: {INSTANCE_URL}")
