# Docker-cgwire

Docker compose for [Kitsu](https://kitsu.cg-wire.com/) and [Zou](https://zou.cg-wire.com/)

### Usage

For the first launch

```bash
bash build.sh -i
```

Then

```bash
bash build.sh
```

#### Use local images

```bash
bash get_build_dependencies.sh  #clone Kitsu and Zou Dockerfiles into subfolders

# For the first launch
bash build.sh -i -b 
# Then
bash build.sh -b
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