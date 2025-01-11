#!/bin/bash

wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz
tar xfz linux-amd64-1.1.0.tar.gz
sudo cp linux-amd64-1.1.0/ccat /usr/local/bin/
sudo chmod +x /usr/local/bin/ccat
rm -r linux-amd64-1.1.0
rm linux-amd64-1.1.0.tar.gz

echo "ccat have been installed successfully."