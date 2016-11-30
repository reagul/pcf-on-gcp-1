### PCF - GCP Automation Scripts

## Prerequisites

  1. The GCP command-line tool `gcloud` ([get it here](https://cloud.google.com/sdk/))
  2. `jq` for parsing JSON outputs ([installation instructions](https://stedolan.github.io/jq/download/))
  3. A [Pivotal Network](https://network.pivotal.io) account and API token.

## Inputs

Add a file named `personal.sh` to include your Google account, Google project, and domain:

```
ACCOUNT="your-account@your-domain-or-gmail.com"
PROJECT="your-project"
DOMAIN="domain-for-your-pcf-install.tld"
```

You can add other variables there to override the variables in `lib/env.sh`. Some of those will move into commandline arguments soon,
but you can customize them otherwise using `personal.sh` today. You should look through `lib/env.sh` to make sure you are happy with the
defaults (especially the region and availability zone variables, and the various product version variables).

There is also an assumption that the environment variable `PIVNET_TOKEN` is set in your environment (I do that in my `.zshenv`). If you
don't already have it set to your Pivotal Network API token, you can set that in `personal.sh` as well.

## Steps to Install

The installation is split into two steps, one to prepare the Google cloud infrastructure for your installation, another to install products.
Currently the product installation can install Cloud Foundry, MySQL, Rabbit MQ, Redis, the GCP Service Broker, Gemfire, and Concourse. More products
will be added later.

```
$ prepare.sh
```

In between the two steps, there you need to go into the Ops Manager UI and configure the Google Cloud Platform tile. This will start the BOSH
director in your environment.  There are some steps there that are not easily done via the Ops Manager APIs, though I have some ideas and may
be able to do some additional automation there.

**NOTE: When you run the install script you will be accepting the EULA(s) for the product(s) you are installing. I strongly recommend you review
any EULA you are agreeing to before you accept it.**

```
$ install.sh
```

This will install the defaults, which are Cloud Foundry, MySQL, Rabbit MQ, Redis, and the GCP Service Broker. You can also specify individual
products. See the usage for the command.

```
$ install.sh --help
install.sh [ pcf ] [ mysql ] [ rabbit ] [ redis ] [ scs ] [ gcp ] [ gemfire ] [ concourse ]
```

## Starting and stopping

Two scripts `start.sh` and `stop.sh` will start and stop the instances that are running your PCF installation at the GCP level. They take
advantage of the tag that BOSH adds to all instances. Since the instanes all have a common tag, the scripts use the `gcloud` CLI to find those
instances and start/stop them with other CLI calls.

## Customizing

The file `lib/customization_hooks.sh` contains default functions that are meant to be "overridden" in `personal.sh` to change the behavior
of the other scripts. At this point, the only available customization is a script to update the root DNS for the domain you are installing
for.  I needed this because I was using a domain managed at Amazon but managing the subdomain DNS for this installation at Google using
these scripts.  You might need something similar if you aren't managing the domain at Google.

## Steps to Uninstall

Use the `teardown.sh` script to teardown your installation. There will be no trace of it left on GCP.

```
teardown.sh
```

That's it. You can check the [Google Cloud Platform console](https://console.cloud.google.com) and you'll see all the resources are gone.
