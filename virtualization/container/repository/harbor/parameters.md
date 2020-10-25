# Required parameters：

* **hostname**: The target host's hostname, which is used to access the UI and the registry service. It should be the IP address or the fully qualified domain name (FQDN) of your target machine, e.g., `192.168.1.10` or `reg.yourdomain.com`. _Do NOT use `localhost` or `127.0.0.1` for the hostname - the registry service needs to be accessible by external clients!_ 
* **ui_url_protocol**: (**http** or **https**.  Default is **http**) The protocol used to access the UI and the token/notification service.  If Notary is enabled, this parameter has to be _https_.  By default, this is _http_. To set up the https protocol, refer to **[Configuring Harbor with HTTPS Access](configure_https.md)**.  
* **db_password**: The root password for the MySQL database used for **db_auth**. _Change this password for any production use!_ 
* **max_job_workers**: (default value is **3**) The maximum number of replication workers in job service. For each image replication job, a worker synchronizes all tags of a repository to the remote destination. Increasing this number allows more concurrent replication jobs in the system. However, since each worker consumes a certain amount of network/CPU/IO resources, please carefully pick the value of this attribute based on the hardware resource of the host. 
* **customize_crt**: (**on** or **off**.  Default is **on**) When this attribute is **on**, the prepare script creates private key and root certificate for the generation/verification of the registry's token. Set this attribute to **off** when the key and root certificate are supplied by external sources. Refer to [Customize Key and Certificate of Harbor Token Service](customize_token_service.md) for more info.
* **ssl_cert**: The path of SSL certificate, it's applied only when the protocol is set to https
* **ssl_cert_key**: The path of SSL key, it's applied only when the protocol is set to https 
* **secretkey_path**: The path of key for encrypt or decrypt the password of a remote registry in a replication policy.
* **log_rotate_count**: Log files are rotated **log_rotate_count** times before being removed. If count is 0, old versions are removed rather than rotated.
* **log_rotate_size**: Log files are rotated only if they grow bigger than **log_rotate_size** bytes. If size is followed by k, the size is assumed to be in kilobytes. If the M is used, the size is in megabytes, and if G is used, the size is in gigabytes. So size 100, size 100k, size 100M and size 100G are all valid.

# Optional parameters：

* **Email settings**: These parameters are needed for Harbor to be able to send a user a "password reset" email, and are only necessary if that functionality is needed.  Also, do note that by default SSL connectivity is _not_ enabled - if your SMTP server requires SSL, but does _not_ support STARTTLS, then you should enable SSL by setting **email_ssl = true**. Setting **email_insecure = true** if the email server uses a self-signed or untrusted certificate. For a detailed description about "email_identity" please refer to [rfc2595](https://tools.ietf.org/rfc/rfc2595.txt)
  * email_server = smtp.mydomain.com 
  * email_server_port = 25
  * email_identity = 
  * email_username = sample_admin@mydomain.com
  * email_password = abc
  * email_from = admin <sample_admin@mydomain.com>  
  * email_ssl = false
  * email_insecure = false

* **harbor_admin_password**: The administrator's initial password. This password only takes effect for the first time Harbor launches. After that, this setting is ignored and the administrator's password should be set in the UI. _Note that the default username/password are **admin/Harbor12345** ._   
* **auth_mode**: The type of authentication that is used. By default, it is **db_auth**, i.e. the credentials are stored in a database. 
For LDAP authentication, set this to **ldap_auth**.  

   **IMPORTANT:** When upgrading from an existing Harbor instance, you must make sure **auth_mode** is the same in ```harbor.cfg``` before launching the new version of Harbor. Otherwise, users 
may not be able to log in after the upgrade.
* **ldap_url**: The LDAP endpoint URL (e.g. `ldaps://ldap.mydomain.com`).  _Only used when **auth_mode** is set to *ldap_auth* ._ 
* **ldap_searchdn**: The DN of a user who has the permission to search an LDAP/AD server (e.g. `uid=admin,ou=people,dc=mydomain,dc=com`).
* **ldap_search_pwd**: The password of the user specified by *ldap_searchdn*.
* **ldap_basedn**: The base DN to look up a user, e.g. `ou=people,dc=mydomain,dc=com`.  _Only used when **auth_mode** is set to *ldap_auth* ._ 
* **ldap_filter**:The search filter for looking up a user, e.g. `(objectClass=person)`.
* **ldap_uid**: The attribute used to match a user during a LDAP search, it could be uid, cn, email or other attributes.
* **ldap_scope**: The scope to search for a user, 0-LDAP_SCOPE_BASE, 1-LDAP_SCOPE_ONELEVEL, 2-LDAP_SCOPE_SUBTREE. Default is 2. 
* **self_registration**: (**on** or **off**. Default is **on**) Enable / Disable the ability for a user to register himself/herself. When disabled, new users can only be created by the Admin user, only an admin user can create new users in Harbor.  _NOTE: When **auth_mode** is set to **ldap_auth**, self-registration feature is **always** disabled, and this flag is ignored._  
* **token_expiration**: The expiration time (in minutes) of a token created by token service, default is 30 minutes.
* **project_creation_restriction**: The flag to control what users have permission to create projects.  By default everyone can create a project, set to "adminonly" such that only admin can create project.
