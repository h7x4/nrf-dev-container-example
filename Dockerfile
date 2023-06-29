FROM ubuntu:latest

ARG NRF_COMMAND_LINE_TOOLS_VERSION=10-21-0/nrf-command-line-tools_10.21.0
ARG NRF_CONNECT_SDK_VERSION=v2.3.0

RUN apt-get update
RUN apt-get install --no-install-recommends --yes \
  ca-cacert \
  wget

# https://www.nordicsemi.com/Products/Development-tools/nrf-command-line-tools/download
RUN wget https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/${NRF_COMMAND_LINE_TOOLS_VERSION}_amd64.deb -O /root/nrf-command-line-tools.deb
RUN apt-get install -y /root/nrf-command-line-tools.deb
RUN apt-get install -y /opt/nrf-command-line-tools/share/JLink_Linux_*.deb
RUN rm /root/nrf-command-line-tools.deb /opt/nrf-command-line-tools/share/JLink_Linux_*.deb

# https://www.nordicsemi.com/Products/Development-tools/nrf-util
RUN wget "https://developer.nordicsemi.com/.pc-tools/nrfutil/x64-linux/nrfutil" -O /usr/bin/nrfutil
RUN chmod +x /usr/bin/nrfutil
RUN nrfutil install toolchain-manager
RUN nrfutil toolchain-manager install --ncs-version ${NRF_CONNECT_SDK_VERSION}
RUN nrfutil toolchain-manager env --as-script sh >> /etc/envvars
RUN echo "source /etc/envvars" >> /etc/profile
RUN echo "source /etc/envvars" >> /etc/bash.bashrc

CMD ["/usr/bin/env", "bash"]
