**NOTE** This repo is archived, use the [official image](https://hub.docker.com/_/hitch) instead.

# Hitch Docker Image

This project builds and ships [Hitch](https://github.com/varnish/hitch) as a Docker image.
Hitch is a scalable TLS proxy by Varnish Software.
The docker image is based on [Alpine Linux Docker Image](https://hub.docker.com/_/alpine) which provides a tiny base image.

If you have any problems with this image please report issues on Github.
Pull requests & suggestions are also welcome.

Hitch is built from the latest stable tarball.
We provide tags for the according Hitch version and also a `latest` version pointing to the most recent tag.
In case we have to re-release a version we add `_1` or alike to the version, for example `1.3.1_1`.

### Hitch environment variables

You can change its behavior by changing the following environment variables:

```
HITCH_PEM    /etc/ssl/hitch/combined.pem
HITCH_PARAMS "--backend=[localhost]:80 --frontend=[*]:443"
HITCH_CIPHER EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
```

Please refer to the Hitch help page and the Github repository documentation for more information.

### Use the pre built image

The pre built image can be downloaded using Docker.

```sh
docker pull ghcr.io/zazukoians/hitch
```

### Build the Docker image by yourself

You can also adjust and build the image according to your needs. Just clone the repository and then execute the build command.

```sh
docker build -t ghcr.io/zazukoians/hitch .
```

### Start the container

The container has all pre requisites to run Hitch. In case you do not provide your own SSL certificate it will create its own self-signed SSL certificate on first startup according to the [Hitch documentation](https://github.com/varnish/hitch/blob/master/docs/certificates.md).

By default it will create a certificate for the domain `example.com`, you can override this by providing another name via environment variables. This is not very useful for production but you can start playing around with the image.

```sh
docker run --rm -i -d -p 80 -e DOMAIN=myown.example.com ghcr.io/zazukoians/hitch
```

Note that this alone won't be very useful as the default configuration points to a backend server like Varnish on localhost port 80.
This will not work as there is no such server running in this image.
Instead combine this image with an instance of a proxy like Varnish Cache.
Link the proxy port to this image and point to the correct backend by adjusting the `--backend` option in `HITCH_PARAMS`.

In our setup we override `/etc/ssl/hitch` by a local directory on the Docker host containing the real certificate and then we `link` the hitch image with an instance of Varnish Cache, for example:

```sh
docker run -p 443:443 --name my-hitch -e HITCH_PEM=/etc/ssl/hitch/myreal.pem -e HITCH_PARAMS="--backend=[varnish]:80 --frontend=[*]:443" --link my-varnish:varnish -v /full/path/on/docker/host/to/conf/hitch/certs:/etc/ssl/hitch ghcr.io/zazukoians/hitch
```

This assumes that there is another Docker image called `my-varnish` available and it points hitch to this machine.
Adjust the name according to whatever Varnish image you might use.
We maintain our own version available [here](https://github.com/zazukoians/docker-varnish).

#### Start the container and keep control

The command above starts the container and runs it in foreground.
You can get a console in this image by executing:

```sh
docker run -it -p 443 ghcr.io/zazukoians/hitch /bin/bash
```
