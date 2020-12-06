# Running a DNS over HTTPS Client

There are several DNS over HTTPS (DoH) clients you can use to connect to 1.1.1.1 in order to protect your DNS queries from privacy intrusions and tampering.

## Dnscrypt-proxy

The [dnscrypt-proxy](https://dnscrypt.info) 2.0+ supports DoH out of the box. It supports both 1.1.1.1, and other services. It includes more advanced features, such as load balancing and local filtering.

```bash
sudo apt-get install resolvconf dnscrypt-proxy
sudo sed -i 's/^\(server_names\).*/\1\ =\ '"['cloudflare',\ 'cloudflare-ipv6']/" '/etc/dnscrypt-proxy/dnscrypt-proxy.toml'
sudo systemctl restart network-manager resolvconf
```

## References

[1] N. Congleton, “How to Encrypt Your DNS With DNSCrypt on Ubuntu and Debian - LinuxConfig.org,” 2018. https://linuxconfig.org/how-to-encrypt-your-dns-with-dnscrypt-on-ubuntu-and-debian (accessed Oct. 18, 2020).
