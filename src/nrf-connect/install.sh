#!/usr/bin/env bash
set -eo pipefail

apt-get update
apt-get install --no-install-recommends --yes \
  ca-cacert \
  wget

echo "Installing nRF Command Line Tools ${sdk_version}"
# https://www.nordicsemi.com/Products/Development-tools/nrf-command-line-tools/download
wget https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/${command_line_tools_version}_amd64.deb -O /root/nrf-command-line-tools.deb
apt-get install -y /root/nrf-command-line-tools.deb
apt-get install -y /opt/nrf-command-line-tools/share/JLink_Linux_*.deb
rm /root/nrf-command-line-tools.deb /opt/nrf-command-line-tools/share/JLink_Linux_*.deb


echo "Installing nrfutil"
# https://www.nordicsemi.com/Products/Development-tools/nrf-util
wget "https://developer.nordicsemi.com/.pc-tools/nrfutil/x64-linux/nrfutil" -O /usr/bin/nrfutil
chmod +x /usr/bin/nrfutil

echo "Installing toolchain-manager"
nrfutil install toolchain-manager
nrfutil toolchain-manager install --ncs-version ${sdk_version}
nrfutil toolchain-manager env --as-script sh >> /etc/envvars
echo "source /etc/envvars" >> /etc/profile
echo "source /etc/envvars" >> /etc/bash.bashrc

echo "Installing nRF Connect SDK"
# https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/getting_started/installing.html
mkdir /ncs
pushd /ncs
. /etc/envvars
west init -m https://github.com/nrfconnect/sdk-nrf --mr ${NRF_CONNECT_SDK_VERSION}
west update -n -o=--depth=1 -o=-j4
west zephyr-export
# Some steps have been skipped, because the tools are already included in the toolchain

popd