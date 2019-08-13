# OpenVPN tips

## Determining whether to use a routed or bridged VPN

Overall, routing is probably a better choice for most people, as it is more efficient and easier to set up (as far as the OpenVPN configuration itself) than bridging.
Routing also provides a greater ability to selectively control access rights on a client-specific basis.

I would recommend using routing unless you need a specific feature which requires bridging, such as:

- the VPN needs to be able to handle non-IP protocols such as IPX,
- you are running applications over the VPN which rely on network broadcasts (such as LAN games), or
- you would like to allow browsing of Windows file shares across the VPN without setting up a Samba or WINS server.

[source](https://openvpn.net/community-resources/how-to/#determining-whether-to-use-a-routed-or-bridged-vpn)

## Ethernet Bridging

### Ethernet Bridging Notes

When using an ethernet bridging configuration, the first step is to construct the ethernet bridge — a kind of virtual network interface which is a container for other ethernet interfaces, either real as in physical NICs or virtual as in TAP interfaces.
The ethernet bridge interface must be set up before OpenVPN is actually started.

