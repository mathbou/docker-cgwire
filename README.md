# Docker-cgwire

Docker compose for [Kitsu](https://kitsu.cg-wire.com/) and [Zou](https://zou.cg-wire.com/)

### Usage

```bash
bash build.sh
```

#### Use local images

```bash
bash get_build_dependencies.sh  #clone Kitsu and Zou Dockerfiles into subfolders

bash build.sh -b 
```

#### Flags:

```
    -i, --init              Init Zou and the database (Required for the first launch)
    -b, --build             Use local images
    -e, --env=ENV_FILE      Set custom env file. If not set ./env is used
    -d, --down              Compose down the stack
    -h, --help              Show this help
```

### Default credentials:

* login: admin@example.com
* password: mysecretpassword


### About authors

Those Dockerfiles are based on CG Wire work, a company based in France. They help small
to midsize CG studios to manage their production and build a pipeline
efficiently.

They apply software craftsmanship principles as much as possible. They love
coding and consider that strong quality and good developer experience matter a lot.
Through their diverse experiences, they allow studios to get better at doing
software and focus more on  artistic work.

Visit [cg-wire.com](https://cg-wire.com) for more information.

[![CGWire Logo](https://zou.cg-wire.com/cgwire.png)](https://cgwire.com)