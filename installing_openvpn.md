# OpenVPN for Ubuntu 18.04

### Using OpenVPN apt repositories

OpenVPN Inc. maintains several OpenVPN (OSS) software repositories.
To setup the repositories you need to change to the root user. Typically this is done using sudo: 

```bash
sudo -s
```

Then import the public GPG key that is used to sign the packages:

```bash
wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
```

Next you need to create a sources.list fragment (as root) so that apt can find the new OpenVPN packages. One way to do it is this:

```bash
echo "deb http://build.openvpn.net/debian/openvpn/release/2.4 bionic main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
```

### Installing OpenVPN

```bash
sudo apt update
sudo apt install openvpn
```

### References

[OpenvpnSoftwareRepos](https://community.openvpn.net/openvpn/wiki/OpenvpnSoftwareRepos)
