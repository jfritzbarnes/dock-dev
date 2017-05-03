> simple development environment for node

# contents

* based on node image
* simple dev utilities: less, vim, jq (json processor), httpie
* aws cli utilities

# running an environment

uses docker secrets for providing aws credentials to the image, docker swarm required
typical execution:

```sh
$ docker service create --name devel --network devel --secret aws.config --secret aws.credentials jfritzbarnes/devel:latest
```
# build

```sh
$ docker build -t [name] .
```

# publish

```sh
$ docker push [name]
```
