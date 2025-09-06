#!/bin/bash
set -e

SECRET_DIR=/opt/secrets

echo "🔐 Generating TLS certs for SNI..."

mkdir -p "${SECRET_DIR}"

# ping.local cert => mapped to key.manager.secret.id
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 \
  -subj "/CN=ping.local/OU=example/O=com/L=fr/ST=fr/C=fr" \
  -keyout ${SECRET_DIR}/ping.local-key.pem \
  -out ${SECRET_DIR}/ping.local-certificate.pem
cat ${SECRET_DIR}/ping.local-key.pem ${SECRET_DIR}/ping.local-certificate.pem > ${SECRET_DIR}/key.manager.secret.id.pem

# wildcard.local cert => mapped to wildcard.secret.id
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 \
  -subj "/CN=*.local/OU=example/O=com/L=fr/ST=fr/C=fr" \
  -keyout ${SECRET_DIR}/wildcard.local-key.pem \
  -out ${SECRET_DIR}/wildcard.local-certificate.pem
cat ${SECRET_DIR}/wildcard.local-key.pem ${SECRET_DIR}/wildcard.local-certificate.pem > ${SECRET_DIR}/wildcard.secret.id.pem

# fallback cert => mapped to default.secret.id
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 \
  -subj "/CN=default.local/OU=example/O=com/L=fr/ST=fr/C=fr" \
  -keyout ${SECRET_DIR}/default.local-key.pem \
  -out ${SECRET_DIR}/default.local-certificate.pem
cat ${SECRET_DIR}/default.local-key.pem ${SECRET_DIR}/default.local-certificate.pem > ${SECRET_DIR}/default.secret.id.pem

echo "✅ TLS certificates ready. Starting PingGateway..."

exec ${INSTALL_DIR}/bin/start.sh ${IG_INSTANCE_DIR}
