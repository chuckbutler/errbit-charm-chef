Errbit
--------

This charm provides errbit from http://errbit.github.io/errbit/. Errbit is a tool for collecting and managing errors from other applications. It is Airbrake (formerly known as Hoptoad) API compliant, so if you are already using Airbrake, you can just point the airbrake gem to your Errbit server. The Airbrake protocol has agents for all major languages/frameworks: Ruby, PHP, Java, .Net, Python, and Node.js 


Usage
-----

#### Basic Usage

To deploy the service:

```
    juju deploy errbit
```

By default this deploys the Errbit application Stack: Ruby 1.9.3, Nginx, Sendmail, MongoDB, and the Errbit Application.

You can then browse to http://ip-address to configure the service. 


The application is bootstrapped by default with an administrative user

```
 Login: errbit@errbit.example.com
	 Pass: password
```

Use these credentials to create your new administrative user, and delete the default administrator.

You can validate your errbit installation in any rails app. 

Ensure that you have the airbrake gem included in your Gemfile

```
gem 'airbrake' 
```

Then add the following to config/initializers/errbit.rb
```
Airbrake.configure do |config|
  config.api_key = '123456'
  config.host    = 'example.com'
  config.port    = 80
  config.secure  = config.port == 443
end
```
Respectively, change the api_key and config.host with the values provided from errbit.

### To Scale Up
```
juju deploy mongodb
juju add-relation errbit mongodb
juju add-unit errbit
```

This will deploy a MongoDB server, which is required for operating errbit with more than a single unit. 

**Note** This contains an experimental feature, Errbit will perform a mongodump to /mnt of the units MongoDB Data, then pre-load the MongoDB relationship with a copy of its data and purge the MongoDB-10gen package on the errbit units. 

### To Scale Down

```
juju remove-unit errbit
```





Configuration
-------------

**Default Administrative User**
This charm deploys a default administrative user. These credentials should be used to create your administrative account, and disabled immediately.

```
	Login: errbit@errbit.example.com
	Pass: password
```

### Charm Configuration Options

#### Deploy Resource Configuration
repository:
Configures the repository to deploy Errbit from. Defaults to `https://github.com/errbit/errbit.git`

release:
The tag or branch to deploy from git. Defaults to `v0.2.0`

#### Email Configuration

By default Errbit ships with sendmail, and is configured to route email through the sendmail daemon. If you have other needs, such as routing your email through a company SMTP server, or hosted email service like Mandrill, these settings are for you.

use_sendmail:
Blanket configuration option to route email through the Sendmail daemon.

smtp_host:
Fully qualified url to your SMTP server

smtp_domain:
description: "Domain to send emails from"

smtp_port:
SMTP Port

smtp_user:
SMTP User to login to the SMTP Server and send email from

smtp_pass:
SMTP Password

smtp_starttls_auto:
Start TLS authentication automatically

#### Application Configuration
 
gravatar:
Gravatar Image Set. Options are: mm, identicon, monsterid, wavatar, or retro. Defaults to identicon.

hostname:
Hostname used to access errbit, also used to populate the base URL in email and service notifications.

unicorn_workers:
Number of unicorn workers

debug:
Enable debug level output from chef provisioner


Errata
-----------

Currently the Data migration features are to be considered beta. The scripts only run mongodump and mongorestore on the mongodb-relation hooks. It is always a good idea to fetch backups before performing a migration with production data.

Currently there is no means to prevent the errbit sample administrative user from being re-created on unit scale. After scaling the service you will be required to log in and remove this sample user.

During the errbit-relation-joined phase, you may occasionally receive an error on the unit during the secret-token handoff. This happens when the MongoDB relationship hooks are executing during the same run-loop as the errbit relationship hooks are executing. Retry'ing the operation solves the error and propagates the secret-token successfully. 

When scaling the unit up and down you will experience downtime and dropped connections. The deployment script currently does not version the running copy and execute a fork handoff. This feature is planned for a future iteration. 

Contact Information
-------------------


Author: Charles Butler <chuck@dasroot.net>
Report bugs at: https://github.com/chuckbutler/errbit-charm-chef/issues
Location: http://jujucharms.com/charms/precise/errbit

