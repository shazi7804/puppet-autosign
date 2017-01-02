# puppet Policy-based autosigning sample
Authentication based on challengePassword.

### Install

```
$ chmod +x setup.sh
$ ./setup.sh install
```

### How to Generate Tokens
```
./autosign -c example.com
```
```
Autosign generate infomation:

  node = example.com
  verify file = /opt/autosign/pks/example.com

custom_attributes:

  challengePassword = 31ba7af5a3865af3961d72a9dd5dcd74

Generate secret "example.com" finish, ready to wait for validation.
```

### add custom_attributes
The resulting output can be copied to /etc/puppet/csr_attributes.yaml on an agent machine prior to running puppet for the first time to add the token to the CSR as the challengePassword OID.

```
vim /etc/puppetlabs/puppet/csr_attributes.yaml

custom_attributes:
  challengePassword: "31ba7af5a3865af3961d72a9dd5dcd74"
```


Enjoy your automation work.
