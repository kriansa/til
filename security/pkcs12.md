# PKCS #12

Also known as PFX or P12, a `PKCS #12` file is an archive containing a X.509
certificate (along with its CA) and a private key.

To connect to a SSL secure server you must break it into PEM (X.509) files. To
do that, use the following commands:

```sh
$ openssl pkcs12 -in file.pfx -out ca.pem -cacerts -nokeys
$ openssl pkcs12 -in file.pfx -out client.pem -clcerts -nokeys
$ openssl pkcs12 -in file.pfx -out key.pem -nocerts
```

And to test it, use `curl`:
```
$ curl https://www.thesitetoauthenticate.com/ -v --key key.pem --cacert ca.pem --cert client.pem
```

This stuff is also mentioned on `curl` thread at http://curl.haxx.se/mail/archive-2005-09/0138.html
