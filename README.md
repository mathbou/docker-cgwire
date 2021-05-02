# Docker-cgwire

Docker compose for [Kitsu](https://kitsu.cg-wire.com/) and [Zou](https://zou.cg-wire.com/)

## Usage

```bash
bash build.sh
```

#### Use local images

```bash
bash get_build_dependencies.sh  #clone Kitsu and Zou Dockerfiles into subfolders

bash build.sh -l 
```

#### Flags:

```
    -l, --local             Use local images
    -e, --env=ENV_FILE      Set custom env file. If not set ./env is used
    -d, --down              Compose down the stack
    -h, --help              Show this help
```

## LDAP

Add your [LDAP variables](https://zou.cg-wire.com/configuration/#ldap) to the env file.

```bash
bash ldap_sync.sh
```

#### LDAP flags

```
    -e, --env=ENV_FILE      Set custom env file, must be the same as the env used with build.sh
    -h, --help              Show this help
```

## DB Upgrade

**[- Be sure to backup your datas before upgrading. -]**

```bash
# bash db_upgrade [options] oldDbVersion newDbVersion

# PostgreSql 9.5 to 11

bash db_upgrade 9.5 11
```

Don't forget to update the DB_VERSION key in your 'env' file **after** the upgrade. 

#### DB Upgrade flags

```
    -e, --env=ENV_FILE      Set custom env file, must be the same as the env used with build.sh
    -d, --dry-run           
    -h, --help              Show this help
```

## Default credentials:

* login: admin@example.com
* password: mysecretpassword

## About authors

Those Dockerfiles are based on CG Wire work, a company based in France. They help small
to midsize CG studios to manage their production and build a pipeline
efficiently.

They apply software craftsmanship principles as much as possible. They love
coding and consider that strong quality and good developer experience matter a lot.
Through their diverse experiences, they allow studios to get better at doing
software and focus more on  artistic work.

Visit [cg-wire.com](https://cg-wire.com) for more information.

[![CGWire Logo](https://zou.cg-wire.com/cgwire.png)](https://cgwire.com)
