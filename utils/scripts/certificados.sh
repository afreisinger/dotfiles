#!/bin/bash

# Directorio de certificados (ajusta según tus necesidades)
CERT_DIR="/usr/local/share/ca-certificates"
CERT_FILES=("RootCA2.crt" "AfipSSLCA.crt")

# Asegúrate de que el directorio de certificados existe
if [ ! -d "$CERT_DIR" ]; then
  echo "El directorio $CERT_DIR no existe. Créalo y coloca los certificados dentro."
  exit 1
fi

# Iterar sobre cada certificado y agregarlo al System Keychain
for CERT in "${CERT_FILES[@]}"; do
  CERT_PATH="$CERT_DIR/$CERT"

  if [ ! -f "$CERT_PATH" ]; then
    echo "Certificado $CERT_PATH no encontrado. Saltando..."
    continue
  fi

  # Convertir a formato PEM si es necesario
  PEM_CERT="${CERT%.crt}.pem"
  openssl x509 -in "$CERT_PATH" -out "$CERT_DIR/$PEM_CERT" -outform PEM

  # Agregar al System Keychain
  sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$CERT_DIR/$PEM_CERT"
  if [ $? -eq 0 ]; then
    echo "Certificado $CERT_PATH agregado exitosamente al System Keychain."
  else
    echo "Error al agregar $CERT_PATH al System Keychain."
  fi
done

echo "Proceso completado."
