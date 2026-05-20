#!/bin/sh
set -eu

CONFIG_TEMPLATE="/etc/config.template.json"
CONFIG="/etc/config.json"
CERT_DIR="/etc/xray"

mkdir -p "$CERT_DIR"

generate_uuid() {
    prefix="4b616b6f-6f6c-4e65-7773"
    suffix=$(od -An -tx1 -N6 /dev/urandom | tr -d ' \n')
    echo "${prefix}-${suffix}"
}

UUID="${VLESS_UUID:-$(generate_uuid)}"
SNI="${CODESPACE_NAME:-localhost}-443.app.github.dev"

# Generate self-signed certificate
openssl req -x509 -newkey rsa:2048 -nodes \
  -keyout "$CERT_DIR/key.pem" \
  -out "$CERT_DIR/cert.pem" \
  -subj "/CN=${SNI}" \
  -days 365

# Build config
sed -e "s|\${UUID}|$UUID|g" \
    -e "s|\${SNI}|$SNI|g" \
    "$CONFIG_TEMPLATE" > "$CONFIG"

echo ""
echo "========================================"
echo "  @Kakoolnews - VLESS TLS Proxy"
echo "========================================"
echo ""
echo "VLESS Link:"
echo "vless://${UUID}@${CODESPACE_NAME}-443.app.github.dev:443?encryption=none&security=tls&type=ws&sni=${SNI}&path=%2F#@Kakoolnews"
echo ""
echo "========================================"
echo ""

/usr/local/bin/xray -c "$CONFIG"
