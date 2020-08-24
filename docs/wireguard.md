# WireGuard Configuration <!-- omit in toc -->

## Contents <!-- omit in toc -->

- [Overview](#overview)
- [Installation](#installation)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Configuring WireGuard to run automatically on system startup](#configuring-wireguard-to-run-automatically-on-system-startup)
- [Testing](#testing)
- [References](#references)

## Overview

WireGuard is an extremely simple yet fast and modern VPN that utilizes **state-of-the-art** [cryptography](https://www.wireguard.com/protocol/).
It aims to be [faster](https://www.wireguard.com/performance/), [simpler](https://www.wireguard.com/quickstart/), leaner, and more useful than other VPN protocols such as IPsec and OpenVPN. It is currently under heavy development, but already it might be regarded as the most secure, easiest to use, and simplest VPN solution in the industry.

WireGuard aims to be as easy to configure and deploy as SSH. A VPN connection is made simply by exchanging very simple public keys – exactly like exchanging SSH keys – and all the rest is transparently handled by WireGuard.

WireGuard securely encapsulates IP packets over UDP. You add a WireGuard interface, configure it with your private key and your peers' public keys, and then you send packets across it.

## Installation

```bash
sudo apt-get install wireguard
```

## Configuration

### Quick Start

#### Peer A (Server) <!-- omit in toc -->

```bash
umask 077
ENDPOINT=10.0.0.1/24
LISTEN_PORT=1195

# ufw allow ${LISTEN_PORT}/udp
# ufw enable

# Generate public and private key
wg genkey > private
wg pubkey < private > public

# Add a WireGuard interface
ip link add dev wg0 type wireguard

# Configuration
# 10.0.0.x/24 is peer A's endpoint
ip addr add ${ENDPOINT} dev wg0
wg set wg0 listen-port ${LISTEN_PORT} private-key ./private
ip link set wg0 up

# Configurations for peers
# These variables will depend on your peer
PEER_PUBKEY="$(cat public)"
PEER_ENDPOINT_IP='10.0.0.2'
PEER_IP='192.168.1.2'
PEER_PORT='1195'

wg set wg0 peer ${PEER_PUBKEY} allowed-ips ${PEER_ENDPOINT_IP}/32 endpoint ${PEER_IP}:${PEER_PORT} persistent-keepalive 25
```

#### Peer B (Client) <!-- omit in toc -->

```bash
umask 077
ENDPOINT=10.0.0.2/24
LISTEN_PORT=1195

# ufw allow ${LISTEN_PORT}/udp
# ufw enable

# Generate public and private key
wg genkey > private
wg pubkey < private > public

# Add a WireGuard interface
ip link add dev wg0 type wireguard

# Configuration
# 10.0.0.x/24 is peer A's endpoint
ip addr add ${ENDPOINT} dev wg0
wg set wg0 listen-port ${LISTEN_PORT} private-key ./private
ip link set wg0 up

# Configurations for peers
# These variables will depend on your peer
PEER_PUBKEY="$(cat public)"
PEER_ENDPOINT_IP='10.0.0.1'
PEER_IP='192.168.1.1'
PEER_PORT='1195'

wg set wg0 peer ${PEER_PUBKEY} allowed-ips ${PEER_ENDPOINT_IP}/32 endpoint ${PEER_IP}:${PEER_PORT} persistent-keepalive 25
```

### Configuring WireGuard to run automatically on system startup

Create a configuration file called `wg0.conf` in `etc/wireguard` folder:

```
[Interface]
Address = 10.0.0.x/24
SaveConfig = true
ListenPort = 1195
PrivateKey = <Private key>

[Peer]
PublicKey = <Public key>
AllowedIPs = <Endpoint IP>/32
Endpoint = <Peer IP>:<port>
PersistentKeepalive = 25
```

Create WireGuard service:

```bash
systemctl enable wg-quick@wg0
```

**Note**

- This must be done at each peer-side.
- `SaveConfig` (optional) tells the configuration file to automatically update whenever a new peer is added while the service is running. However, it also overwrite any peer using DDNS with a static IP, so **it should be used with caution**.

## Testing

```bash
# From peer A
ping 10.0.0.2

# From peer B
ping 10.0.0.1
```

## References

[1] J. Donenfeld, “WireGuard: fast, modern, secure VPN tunnel.” https://www.wireguard.com/ (accessed Aug. 24, 2020).

[1] nixCraft, “Ubuntu 20.04 set up WireGuard VPN server - nixCraft.” https://www.cyberciti.biz/faq/ubuntu-20-04-set-up-wireguard-vpn-server/ (accessed Aug. 24, 2020).
