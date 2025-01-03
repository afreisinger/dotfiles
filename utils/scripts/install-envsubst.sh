#!/bin/bash

# Check if gettext is already installed
if command -v gettext >/dev/null 2>&1; then
    echo "gettext is already installed on the system."
    echo "You can use the envsubst command."
    exit 0
fi

# Download the gettext-runtime file
version="0.22"  # Replace with the latest version if different
filename="gettext-${version}.tar.gz"
url="https://ftp.gnu.org/gnu/gettext/${filename}"

#https://ftp.gnu.org/gnu/gettext/gettext-0.22.tar.gz

echo "Downloading ${filename}..."
#curl -O "${url}"

# Extract the file
echo "Extracting ${filename}..."
tar -xf "${filename}"
#tar -xzf "${filename}" -C "gettext-runtime-${version}" --strip-components=1

# Navigate to the extracted directory
cd "gettext-${version}"

# Compile envsubst
echo "Compiling envsubst..."
./configure --without-included-gettext
make -C gettext-tools msgfmt-envsubst

# Copy envsubst to /usr/local/bin directory
echo "Installing envsubst..."
sudo cp gettext-tools/src/envsubst /usr/local/bin

# Verify the installation
if command -v envsubst >/dev/null 2>&1; then
    echo "envsubst was installed successfully."
else
    echo "There was an issue during the installation of envsubst."
fi

# Cleanup: Remove the downloaded file and extracted directory
echo "Cleaning up temporary files..."
cd ..
rm -rf "gettext-runtime-${version}"
rm "${filename}"

echo "The installation of envsubst has been completed!"
