# OpenPGP

In public key cryptography, a key is really a pair: a public key, and a private key. You use the private key to digitally sign files, and others use the public key to verify the signature. Or, others use the public key to encrypt something, and you use the private key to decrypt it.

As long as only you have access to the private key, other people can rely on your digital signatures being made by you, and you can rely on nobody else being able to read messages encrypted for you. (see: https://wiki.debian.org/Subkeys)

But if you're not familiar with PGP, I suggest you to start by reading [this great article](http://zacharyvoase.com/2009/08/20/openpgp/).

## Key definition

A typical OpenPGP key setup contains:
- one master key
- one or more subkeys
- one or more IDs

## IDs, subkeys and capabilities

A key can have different capabilities, such as:

- [C]ertifying - That's a responsability only assigned to the master key. It's meant to generate new subkeys or certificate keys from another person.
- [E]crypting/decrypting - Quite self explanatory.
- [S]igning - It's meant to prove a authenticity of a file, and making sure its message wasn't corrupted during the transport.
- [A]uthentication - Used for authentication protocols. Currently I'm only aware of a single use-case, which is SSH auth, but [there are probably more](http://security.stackexchange.com/questions/55532/is-there-an-actual-use-for-openpgp-authentication-keys).

## Security good practices

The default setup of a OpenPGP key generates a single master key with [SC] capability, usually one subkey and one id. This is a good way to start, however, we can take additional measures to increase the security of your setup.

While these measures might be a overkill for some or insufficient for others, they're considered good practices, so I suggest you to start doing at least these, and then [move further](https://help.riseup.net/en/gpg-best-practices) - as a wise man once said, there's no such thing as "too much security".

1. Do not store your master key on your day-to-day use computer. Create it in a offline media and only use it for certifying other [sub]keys. In the same sense, disallow the capability of encrypting to the master key - so you'll never end up using it, even accidentally. Doing this will prevent your key to be stolen, and losing all your [web of trust](https://en.wikipedia.org/wiki/Web_of_trust). Remember that your web of trust is transferred transitively to all your subkeys, so you can just 'replace' a subkey in case it gets stolen.
2. Create expirable subkeys and rotate them on a regular basis. That way if your subkey ever get stolen, it will only be able to decrypt messages since those keys were created and before they expire - rather than all your messages ever created.
3. Keep your keys on a HSM. That way, your private keys won't ever be accessible again, as the HSM device doesn't expose it, but rather encrypts/signs your data using commands. I suggest you to take a look at [Yubikey](https://www.yubico.com/products/yubikey-hardware/yubikey4/).

For more detailed info, you can check: http://spin.atomicobject.com/2013/10/23/secure-gpg-keys/

## Generating your key

Let's use the good practices and generate a good GPG key. First you must install `gpg2` with your favorite package manager.

### 1. Creating

In a offline computer, create you key:

```
$ gpg2 --gen-key --expert
```

Now, set the capability of the master key to *[C]ertifying* only, then create 3 subkeys, one for each capability: Encrypting, Signing and Authentication.

Remember to set a expire date to your keys, and create a reminder on your calendar to regenerate them.

### 2. Backup

Now, after the keys are generated, backup them! Copy the `~/.gnupg` folder to a pendrive. That should do it, it's not enough. Let's export them into a file - and even [print it out](http://security.stackexchange.com/questions/16209/is-there-a-standard-for-printing-a-public-key-as-a-barcode) on a paper.

```
$ gpg2 --armor --export-secret-keys <KEY_ID> > /media/USB/<KEY_ID>-secret-key.gpg
$ gpg2 --armor --export-secret-subkeys <KEY_ID> > /media/USB/<KEY_ID>-secret-subkeys.gpg
```

### 3. Delete your master secret key

Yes, you read it right. You won't need your master key again until you need to certify another key, or generate a subkey. Since you've already made your backup, you can remove it.

```
$ gpg2 --delete-secret-key <KEY_ID>
```

This will remove all your private key and subkeys. Now, to make sure your backup is working, let's import only the subkeys secrets again:

```
$ gpg2 --import /media/USB/<KEY_ID>-secret-subkeys.gpg
```

Now, test it:

```
$ gpg2 -K
```

It will show a `sec#` meaning that the private key is not present (it's a stub).

### 4. Setup your HSM card

```
$ gpg2 --card-edit
```

Edit the PIN and the Admin PIN to your card, also rename it and put the URL to retrieve the public key for your private.

The example link for a public keyserver key is: http://pgp.mit.edu/pks/lookup?op=get&search=0x<KEY_ID>

### 5. Move your subkeys to a HSM device

Sending your subkeys to a HSM device means that the keys will no longer be available in your machine, but rather in your device. It won't expose your private keys, instead, gpg will send the data to be encrypted to your device, which will encrypt it and send the data back.

```
$ gpg2 --edit-key <KEY_ID>
> toggle
> key 1
> keytocard
```

Repeat this process for all 3 keys that you've created, and then:

```
> save
```

That will move your keys to the card, you can test it by:

```
$ gpg2 -K
sec#  3072R/B8EFD59D 2015-01-02 [expires: 2016-01-02]
uid                  Eric Severance <esev@esev.com>
ssb>  2048R/EE86E896 2015-01-02
ssb>  2048R/79BF574F 2015-01-02
ssb>  2048R/934AE2EE 2015-01-02
```

The `>` means that the keys aren't in your computer, but rather in your HSM device.

### 6. Send your public keys to a keyserver

To [distribute](http://security.stackexchange.com/questions/406/how-should-i-distribute-my-public-key) your public key, you can use a keyserver, preferably a [sks poolserver](https://sks-keyservers.net/overview-of-pools.php). ([why?](https://help.riseup.net/en/security/message-security/openpgp/best-practices#use-the-sks-keyserver-pool-instead-of-one-specific-server-with-secure-connections))

In order to use a HKPS server (highly recommended), you'll need to first download its CA certificates. We'll use sks-keyservers. Then [download the CA](https://sks-keyservers.net/sks-keyservers.netCA.pem) and saves it in your machine:

```
$ wget -O $HOME/.gnupg/sks-keyservers.netCA.pem -nv \
    --ca-certificate=/usr/local/etc/openssl/cert.pem \
    https://sks-keyservers.net/sks-keyservers.netCA.pem
```

Now, you'll need to use these parameters in your `~/.gnupg/gpg.conf`:
```
keyserver hkps://hkps.pool.sks-keyservers.net
keyserver-options ca-cert-file=/path/to/CA/sks-keyservers.netCA.pem
keyserver-options no-honor-keyserver-url
```

Then you'll be able to send your keys to the keyserver:

```
$ gpg2 --send-key <KEY_ID>
```

From this step you are good to go! If you want to setup SSH authentication with your key, follow the next step.

### 7. Setup SSH authentication

You have created a Auth key, now it's time to use it. GnuPG provides a gpg-agent that can be used as a [ssh-agent](http://linux.die.net/man/1/ssh-agent). You just have to start it:

```
$ gpg-agent --daemon --enable-ssh-support --write-env-file ~/.gpg-agent-info
```

Copy-and-paste the environment variables into your terminal to enable support for the gpg-agent. The variables are also stored in `~/.gpg-agent-info` which can be sourced in `.bash_profile` when logging in.

```
$ gpgkey2ssh <AUTH_SUBKEY_ID>
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAA ... oSFl8ZpqJ COMMENT
```

This line can be added to `~/.ssh/authorized_keys` on your remote server, and the private key from your HSM will be used to connect to it.

### 9. Generate an revocation certificate

You should generate an revocation token in a case your key gets stolen. That you can alert everyone that this key was compromised and shouldn't be used anymore. This is the worst-case scenario, because you will lose all your web of trust. So keep your primary key very safe, in a offline storage.

```
$ gpg2 --gen-revoke <KEY_ID> > <KEY_ID>-revocation-cert.asc
Create a revocation certificate for this key? (y/N) y
Please select the reason for the revocation:
  0 = No reason specified
  1 = Key has been compromised
  2 = Key is superseded
  3 = Key is no longer used
  Q = Cancel
(Probably you want to select 1 here)
Your decision? 1
Enter an optional description; end it with an empty line:
> Created during key creation, emergency use only.
>
Reason for revocation: Key has been compromised
Created during key creation, emergency use only.
Is this okay? (y/N) y
```

If you ever need to use this certificate, you'll just have to import it, and then send it to the keyservers:

```
$ gpg2 --import /path/to/<KEY_ID>-revocation-cert.asc
$ gpg2 --send-keys <KEY_ID>
```

### 10. Customize your settings

Take a time to read your `~/.gnupg/gpg.conf` file and configure a lot of stuff there.

## Cheatsheet

#### `gpg2 --encrypt <INPUT>`
Needless to say. It will encrypt using a selected recipient's key.

#### `gpg2 --decrypt <INPUT>`
Decrypts a input using a matching key.

#### `gpg2 --refresh-keys`
Fetch new information from the key servers. Good practice is to use `parcimonie` instead, if you're using a unencrypted connection, like hpk.

#### `gpg2 --list-keys` or `gpg2 -k`
List all the public keys in your `pubring.gpg`
```
$ gpg2 -K
sec#  3072R/B8EFD59D 2015-01-02 [expires: 2016-01-02]
uid                  Eric Severance <esev@esev.com>
ssb>  2048R/EE86E896 2015-01-02
ssb>  2048R/79BF574F 2015-01-02
ssb>  2048R/934AE2EE 2015-01-02
```

The `#` means that the private key is not present. The `>` means that the key is stored in HSM card.

#### `gpg2 --list-secret-keys` or `gpg2 -K`
List all the secret keys in your `secring.gpg` (keys that you own)

#### `gpg2 --edit-key [--expert] <KEY_ID>`
Edits a key. The expert flag allows you to generate auth subkeys

#### `gpg2 --gen-key [--expert]`
Generates a new key. The expert flag allows you to edit the capabilities of each key

## Resources
- Long series post of GnuPG: http://spin.atomicobject.com/2013/09/25/gpg-gnu-privacy-guard/
- Understanding the concepts of PGP: http://zacharyvoase.com/2009/08/20/openpgp/
- OpenPGP best practices: https://help.riseup.net/en/security/message-security/openpgp/best-practices
- Using OpenPGP cards: https://we.riseup.net/debian/using-the-openpgp-card-with-subkeys
- Setup guide using good practices: https://wiki.fsfe.org/Card_howtos/Card_with_subkeys_using_backups
- Managing subkeys: https://wiki.debian.org/Subkeys
- More complete guide of setup using good practices: http://blog.josefsson.org/2014/06/23/offline-gnupg-master-key-and-subkeys-on-yubikey-neo-smartcard/
- Setup using a Yubikey: https://jclement.ca/articles/2015/gpg-smartcard/
- Using OpenPGP properly: https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages-on-an-ubuntu-12-04-vps
