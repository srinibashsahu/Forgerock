#!/bin/bash
set -e

DEPLOYMENT_ID_FILE="$DS_HOME/deployment-id.txt"
export DEPLOYMENT_PWD=P@ssword123

# Create deployment ID if not already created
if [ ! -f "$DEPLOYMENT_ID_FILE" ]; then
  echo ">>> Creating Deployment ID..."
  DEPLOYMENT_ID=$($DS_HOME/bin/dskeymgr create-deployment-id \
    --deploymentIdPassword "$DEPLOYMENT_PWD")
  echo "$DEPLOYMENT_ID" > "$DEPLOYMENT_ID_FILE"
fi

# Load the Deployment ID into env var
export DEPLOYMENT_ID=$(cat "$DEPLOYMENT_ID_FILE")

# Run setup if not already configured
if [ ! -d "$DS_HOME/config" ]; then
  echo ">>> Running ForgeRock DS setup..."
  $DS_HOME/setup \
  --deploymentId "${DEPLOYMENT_ID}" \
  --deploymentIdPassword "${DEPLOYMENT_PWD}" \
  --serverId ds1 \
  --hostname localhost \
  --rootUserDn "cn=Directory Manager" \
  --rootUserPassword "$ROOT_USER_PASSWORD" \
  --ldapPort 1389 \
  --ldapsPort 1636 \
  --httpsPort 8443 \
  --adminConnectorPort 4444 \
  --replicationPort 8989 \
  --profile ds-evaluation \
  --start \
  --acceptLicense

fi

# Ensure backend exists
echo ">>> Checking backend..."
$DS_HOME/bin/dsconfig list-backends \
  --hostname "$HOSTNAME" \
  --port "$ADMIN_PORT" \
  --bindDn "$ROOT_USER_DN" \
  --bindPassword "$ROOT_USER_PASSWORD" \
  --usePkcs12TrustStore $DS_HOME/config/keystore \
  --trustStorePassword:file $DS_HOME/config/keystore.pin \
  | grep -q "ciamBackend" || {
    echo ">>> Creating backend ciamBackend..."
    $DS_HOME/bin/dsconfig create-backend \
      --hostname "$HOSTNAME" \
      --port "$ADMIN_PORT" \
      --bindDn "$ROOT_USER_DN" \
      --bindPassword "$ROOT_USER_PASSWORD" \
      --backend-name ciamBackend \
      --type je \
      --set enabled:true \
      --set base-dn:dc=ciam,dc=com \
      --usePkcs12TrustStore $DS_HOME/config/keystore \
      --trustStorePassword:file $DS_HOME/config/keystore.pin \
      --no-prompt
}

# # If LDIF baked into the image, import it once
if [ -f "/ldif/ciam.ldif" ]; then
  echo ">>> Importing LDIF file..."
  $DS_HOME/bin/stop-ds --quiet
  $DS_HOME/bin/import-ldif \
    --offline \
    --backendId ciamBackend \
    --ldifFile /ldif/ciam.ldif
  $DS_HOME/bin/start-ds --quiet
fi


# ...existing code...

echo ">>> Cleaning up stale lock file if present..."
rm -f "$DS_HOME/locks/server.lock"
rm -f "$DS_HOME/db/dsEvaluation/je.lck"
echo ">>> Killing any leftover DS processes..."
pkill -f opendj || true

echo ">>> Starting ForgeRock DS..."
exec $DS_HOME/bin/start-ds --nodetach
