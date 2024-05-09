FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y iproute2 wget make git iputils-ping inetutils-traceroute

# Install Go
RUN wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
RUN rm go1.22.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Validate Go installation
RUN go version

# Install Kubo (formerly IPFS)
RUN wget https://dist.ipfs.tech/kubo/v0.28.0/kubo_v0.28.0_linux-amd64.tar.gz
RUN tar -xvzf kubo_v0.28.0_linux-amd64.tar.gz
RUN cd kubo && bash install.sh
RUN rm -rf kubo kubo_v0.28.0_linux-amd64.tar.gz

# Validate Kubo (IPFS) installation
RUN ipfs --version

# Create start script
RUN echo "#!/bin/bash" > /start.sh
RUN echo "ip link set eth1 up" >> /start.sh
RUN echo "ip link set eth0 down" >> /start.sh
RUN echo "ip addr add \$MY_IP/24 dev eth1" >> /start.sh
RUN echo "ip route del default" >> /start.sh
RUN echo "ip route add 192.168.0.0/16 via \$GATEWAY_IP dev eth1" >> /start.sh
RUN echo "ip route add 10.0.10.0/24 via \$GATEWAY_IP dev eth1" >> /start.sh
RUN echo "ip route add default via \$GATEWAY_IP" >> /start.sh
RUN echo "ipfs init" >> /start.sh
RUN echo "ipfs config --json Addresses.Swarm '[\"/ip4/0.0.0.0/tcp/4001\", \"/ip4/0.0.0.0/udp/4001/quic-v1\", \"/ip4/0.0.0.0/udp/4001/quic-v1/webtransport\"]'" >> /start.sh
RUN echo "ipfs config --json Addresses.API '\"/ip4/127.0.0.1/tcp/5001\"'" >> /start.sh
RUN echo "ipfs config --json Addresses.Gateway '\"/ip4/127.0.0.1/tcp/8080\"'" >> /start.sh
RUN echo "ipfs bootstrap rm --all" >> /start.sh
RUN echo "exec ipfs daemon" >> /start.sh
RUN chmod +x /start.sh

# Set the entry point
# ENTRYPOINT ["/start.sh"]
