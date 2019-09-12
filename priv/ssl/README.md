# Disclaimer

Please note that the included certificate `origami.crt` and private key `origami.key` are publicly available via this repository, and should NOT be used for any secure application. These have been provided here for your testing comfort only.

You may consider getting your copy of OpenSSL <http://www.openssl.org> and generate your own certificate and private key by issuing a command similar to:

```bash
$ openssl req -new -x509 -newkey rsa:1024 -days 365 -keyout origami.key -out origami.crt
```