> development environments

# contents

This has been forked to support a couple of different development environments.
My view on a development environment is somewhat biased. Some goals include:

* based on lanuage images
* extend with additional dev utilities: less, jq (json processor), httpie
* bash setup, expects to use a docker home volume (configuration & setup survives
  across runs, and can be used within multiple containers concurrently)
* uses krypton for managing ssh keys
* aws cli utilities, where applicable

# running an environment

```sh
$ docker run -it --rm --name godock -v devhome:/home/dev -v godir:/go -v /Users/fbarnes/src/github.com/jfritzbarnes/dock-dev:/home/dev/src jfritzbarnes/devgo zsh
```
# build

```sh
$ make gobuild
```

# publish

```sh
$ docker push [name]
```
