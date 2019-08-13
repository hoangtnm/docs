# OpenVPN tips

## Determining whether to use a routed or bridged VPN

Overall, routing is probably a better choice for most people, as it is more efficient and easier to set up (as far as the OpenVPN configuration itself) than bridging.
Routing also provides a greater ability to selectively control access rights on a client-specific basis.

I would recommend using routing unless you need a specific feature which requires bridging, such as:

- the VPN needs to be able to handle non-IP protocols such as IPX,
- you are running applications over the VPN which rely on network broadcasts (such as LAN games), or
- you would like to allow browsing of Windows file shares across the VPN without setting up a Samba or WINS server.

[source](https://openvpn.net/community-resources/how-to/#determining-whether-to-use-a-routed-or-bridged-vpn)

## Expanding the scope of the VPN to include additional machines on either the client or server subnet

**Including multiple machines on the server side when using a routed VPN (dev tun)**

Once the VPN is operational in a point-to-point capacity between client and server, it may be desirable to expand the scope of the VPN so that clients can reach multiple machines on the server network, rather than only the server machine itself.

For the purpose of this example, we will assume that the server-side LAN uses a subnet of **10.66.0.0/24** and the VPN IP address pool uses **10.8.0.0/24** as cited in the server directive in the OpenVPN server configuration file.

First, you must *advertise* the **10.66.0.0/24** subnet to VPN clients as being accessible through the VPN. This can easily be done with the following server-side config file directive:

```
push "route 10.66.0.0 255.255.255.0"
```

Next, you must set up a route on the server-side LAN gateway to route the VPN client subnet (**10.8.0.0/24**) to the OpenVPN server (this is only necessary if the OpenVPN server and the LAN gateway are different machines).

### Including multiple machines on the server side when using a bridged VPN (dev tap)

One of the benefits of using [ethernet bridging](https://openvpn.net/community-resources/ethernet-bridging/) is that you get this for free without needing any additional configuration.

### Including multiple machines on the client side when using a routed VPN (dev tun)

In a typical road-warrior or remote access scenario, the client machine connects to the VPN as a single machine. But suppose the client machine is a gateway for a local LAN (such as a home office), and you would like each machine on the client LAN to be able to route through the VPN.

## Ethernet Bridging

### Ethernet Bridging Notes

When using an ethernet bridging configuration, the first step is to construct the ethernet bridge — a kind of virtual network interface which is a container for other ethernet interfaces, either real as in physical NICs or virtual as in TAP interfaces.
The ethernet bridge interface must be set up before OpenVPN is actually started.

