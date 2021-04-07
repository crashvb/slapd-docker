# slapd

## Overview

This docker image contains [slapd](https://www.openldap.org/) and [phpldapadmin](https://phpldapadmin.sourceforge.net/wiki/).

## Entrypoint Scripts

### slapd

The embedded entrypoint script is located at `/etc/entrypoint.d/10slapd` and performs the following actions:

1. If TLS is enabled, the PKI certificates and Diffie-Hellman parameters are imported.
2. A new ejbca configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | ---------| ------------- | ----------- |
 | LDAP_ADMIN_PASSWORD | | The ldap root password. |
 | LDAP_DOMAIN | example.com | The name of the ldap domain |
 | LDAP_ORGANIZATION | Example Company | The name of the ldap organization. |
 | LDAP_SUFFIX | _derived_ | The corresponding ldap suffix (base DN) |
 | SLAPD_CERT_DAYS | 30 | Validity period of any generated PKI certificates. |
 | SLAPD_KEY_SIZE | 4096 | Key size of any generated PKI keys. |
 | TLS_CIPHER_SUITE | SECURE256:-VERS-TLS-ALL:+VERS-TLS1.3:+VERS-TLS1.2:+VERS-DTLS1.2:+SIGN-RSA-SHA256:%SAFE_RENEGOTIATION:%STATELESS_COMPRESSION:%LATEST_RECORD_VERSION | The TLS ciphers use to restrict connects. |

3. The following configurations are added: `OrganizationalUnits` and `PosixGroups`.
4. The following configurations are modified: `PosixIndices` and `TLSCertificate`.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ entrypoint.d/
│  │  └─ 10slapd
│  └─ supervisor/
│     └─ config.d/
│        └─ slapd.conf
├─ run/
│  └─ secrets/
│     ├─ slapd.crt
│     ├─ slapd.key
│     ├─ slapdca.crt
│     └─ ldap_admin_password
└─ usr/
   └─ local/
      ├─ bin/
      │  ├─ ldap-groupadd
      │  ├─ ldap-groupdel
      │  ├─ ldap-groupmembership
      │  ├─ ldap-passwd
      │  ├─ ldap-root-passwd
      │  ├─ ldap-su-passwd
      │  ├─ ldap-su-useradd
      │  ├─ ldap-su-userdel
      │  ├─ ldap-test
      │  ├─ ldap-useradd
      │  ├─ ldap-userdel
      │  └─ ldap-userhostaccess
      └─ share/
         └─ ldap/
            ├─ *.ldif
            └─ *.template
```

### Exposed Ports

* `389/tcp` - ldap listening port.
* `636/tcp` - ldaps listening port.

### Volumes

* `/etc/ldap` - The slapd configuration directory.
* `/var/lib/ldap` - The slapd data directory.

## Development

[Source Control](https://github.com/crashvb/slapd-docker)

