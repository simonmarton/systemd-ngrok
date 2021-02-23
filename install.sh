#!/usr/bin/env bash
echo 'Installing Ngrok..'

if [ ! $(which wget) ]; then
    echo 'Please install wget package'
    exit 1
fi

if [ ! $(which git) ]; then
    echo 'Please install git package'
    exit 1
fi

if [ ! $(which unzip) ]; then
    echo 'Please install zip package'
    exit 1
fi

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

if [ -z "$1" ]; then
    echo "./install.sh <your_authtoken>"
    exit 1
fi

if [ ! -e ngrok.service ]; then
    sudo -u `logname` git clone --depth=1 https://github.com/simonmarton/systemd-ngrok.git
    cd systemd-ngrok
fi
cp ngrok.service /lib/systemd/system/
mkdir -p /opt/ngrok
cp ngrok.yml /opt/ngrok
sed -i "s/<add_your_token_here>/$1/g" /opt/ngrok/ngrok.yml

cd /opt/ngrok
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd.zip
unzip ngrok-stable-linux-amd.zip
rm ngrok-stable-linux-amd.zip
chmod +x ngrok

echo 'Done, starting service..'

systemctl enable ngrok.service
systemctl start ngrok.service
