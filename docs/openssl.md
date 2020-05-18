# OpenSSL Essentials: Working with SSL Certificates, Private Keys and CSRs <!-- omit in toc -->

This cheat sheet style guide provides a quick reference to OpenSSL commands that are useful in common, everyday scenarios. This includes OpenSSL examples of generating private keys, certificate signing requests, and certificate format conversion. It does not cover all of the uses of OpenSSL.

## Contents <!-- omit in toc -->

- [Resources](#resources)
- [Generating SSL Certificates](#generating-ssl-certificates)
	- [Generate a Self-Signed Certificate](#generate-a-self-signed-certificate)
	- [Generate a Self-Signed Certificate from an Existing Private Key](#generate-a-self-signed-certificate-from-an-existing-private-key)
- [View Certificates](#view-certificates)
	- [View Certificate Entries](#view-certificate-entries)

## Resources

- [Generating a self-signed certificate using OpenSSL](https://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.cmc.doc/task_apionprem_gernerate_self_signed_openSSL.html)
- [OpenSSL Essentials: Working with SSL Certificates, Private Keys and CSRs](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs)

## Generating SSL Certificates

If you would like to use an SSL certificate to secure a service but you do not require a CA-signed certificate, a valid (and free) solution is to sign your own certificates.

A common type of certificate that you can issue yourself is a _self-signed certificate_. A self-signed certificate is a certificate that is signed with its own private key. Self-signed certificates can be used to encrypt data just as well as CA-signed certificates, but your users will be displayed a warning that says that the certificate is not trusted by their computer or browser. Therefore, self-signed certificates should only be used if you do not need to prove your service’s identity to its users (e.g. non-production or non-public servers).

This section covers OpenSSL commands that are related to generating self-signed certificates.

### Generate a Self-Signed Certificate

Use this method if you want to use HTTPS (HTTP over TLS) to secure your Apache HTTP or Nginx web server, and you do not require that your certificate is signed by a CA.

This command creates a 2048-bit private key (`domain.key`) and a self-signed certificate (`domain.crt`) from scratch:

```sh
openssl req \
	-newkey rsa:2048 -nodes -keyout domain.key \
	-x509 -days 365 -out domain.crt
```

Answer the CSR information prompt to complete the process.

The `-x509` option tells `req` to create a self-signed cerificate. The `-days 365` option specifies that the certificate will be valid for 365 days. A temporary CSR is generated to gather information to associate with the certificate.

### Generate a Self-Signed Certificate from an Existing Private Key

Use this method if you already have a private key that you would like to generate a self-signed certificate with it.

This command creates a self-signed certificate (`domain.crt`) from an existing private key (`domain.key`):

```sh
openssl req \
	-key domain.key \
	-new \
	-x509 -days 365 -out domain.crt
```

## View Certificates

Certificate and CSR files are encoded in PEM format, which is not readily human-readable.

This section covers OpenSSL commands that will output the actual entries of PEM-encoded files.

### View Certificate Entries

This command allows you to view the contents of a certificate (`domain.crt`) in plain text:

```sh
openssl x509 -text -noout -in domain.crt
```
