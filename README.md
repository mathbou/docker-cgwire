# Docker-cgwire

Docker compose for [Kitsu](https://kitsu.cg-wire.com/) and [Zou](https://zou.cg-wire.com/)

[TOC]

## Usage

```bash
    build.sh [subcommand] [options]
```

#### Sub-Commands

```bash
    local                   Use local build of Kitsu and Zou containers
    down                    Compose Down the stack
```

#### Options

```
    -e, --env=ENV_FILE      Set custom env file. If not set ./env is used

        --develop           [local, down] Gives access to running code on the host. Clean DB every time it's rebuild.
        --keep-db           [local]Keep develop DB data. Should be combined with `--develop`.
        
    -h, --help              Show this help
```

#### Compose-up the stack

```commandline
bash build.sh
```
This will use prebuilt Kitsu and Zou containers, and use the `env` file as settings.
The setting list for the `env` file can be found [here](https://zou.cg-wire.com/configuration/).

#### Default credentials

* login: admin@example.com
* password: mysecretpassword


## LDAP

Add your [LDAP variables](https://zou.cg-wire.com/configuration/#ldap) to the env file.

```bash
bash sync_ldap.sh
```

#### LDAP options

```
    -e, --env=ENV_FILE      Set custom env file, must be the same as the env used with build.sh
    -h, --help              Show this help
```

## DB Upgrade

**[- Be sure to backup your data before upgrading. -]**

```bash
# bash db_upgrade [options] oldDbVersion newDbVersion

# PostgreSql 10 to 12

bash db_upgrade 10 12
```

Don't forget to update the `DB_VERSION` key in your `env` file **after** the upgrade. 

#### DB Upgrade options

```
    -e, --env=ENV_FILE      Set custom env file, must be the same as the env used with build.sh
    -d, --dry-run           
    -h, --help              Show this help
```

## Build your own images

### Get dependencies:
#### local builds

```bash
bash get_dependencies.sh  # Clone Kitsu and Zou Dockerfiles into sub-folders
```
local build also need those (not required for development stack):

- [jq](https://stedolan.github.io/jq/download/)
- [curl](https://www.tecmint.com/install-curl-in-linux/)

#### Development builds

```bash
bash get_dependencies.sh  # Development stack needs standard build dependencies
bash get_dependencies.sh develop # Clone the official Kitsu and Zou repos from CGwire's Github
```

#### Update dependencies

The `get_dependencies` script provides flag to update them:

```bash
get_dependencies --update # Pull the dependencies
get_dependencies develop --update # Pull the development dependencies
```
```bash
get_dependencies --update --force # Do a `reset --hard` before the pull
get_dependencies develop --update # Do the same for the development dependencies  
```

**Even if those flags works with the `develop` sub-command, 
it's safer to manage the kitsu-dev and zou-dev folders yourself.**

### Build:
#### Local images

In case you want to modify the images, you'll need the [dependencies](#local-builds), and then build them:

```bash
bash build.sh local
```

#### Development images

To actively develop on Kitsu or Zou, you'll need the [dependencies](#development-builds) and a special stack:

```bash
bash build.sh local --develop
```

Kitsu and Zou workspaces are then accessible and can be modified from the host while the stack is running. 
You can found them in the `kitsu-dev` and `zou-dev` folders.
Depending on the modifications, you may need to restart the containers or relaunch the last command to rebuild them.

To prevent conflict with production stacks, a `-dev` suffix is automatically added to the `COMPOSE_PROJECT_NAME` variable.
Also, the default exposed port is `8080`, it can be changed by adding `DEV_PORT` variable to you `env` file.

**[- The development DB is wiped out each time you launch the 'build.sh local --develop' command', unless you specify the '--keep-db' option -]**

# About authors

Those Dockerfiles are based on CG Wire work, a company based in France. They help small
to midsize CG studios to manage their production and build a pipeline
efficiently.

They apply software craftsmanship principles as much as possible. They love
coding and consider that strong quality and good developer experience matter a lot.
Through their diverse experiences, they allow studios to get better at doing
software and focus more on  artistic work.

Visit [cg-wire.com](https://cg-wire.com) for more information.

[![CGWire Logo](https://zou.cg-wire.com/cgwire.png)](https://cgwire.com)
