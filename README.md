# Automated build of Hitch with Docker

This Docker image builds and ships [Hitch](https://github.com/varnish/hitch), a scalable TLS proxy by Varnish Software. It is based on [Alpine Linux Docker Image](http://gliderlabs.viewdocs.io/docker-alpine/) which provides a tiny base image. The full container is less than 8 megabytes.

If you have any problems with this image please report issues. Pull requests are also welcome.

The image is currently built from a Git fork to make sure it compiles on Alpine Linux. This will be replaced by the latest stable tarball once our pull request got accepted.

### Hitch environment variables

You can change its behaviour by changing the following environment variables:

    HITCH_PEM    /etc/ssl/hitch/combined.pem
    HITCH_PARAMS "--backend=[localhost]:80 --frontend=[*]:443"
    HITCH_CYPHER EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH

Please refer to the Hitch help page and the Github repository documentation for more information. 

### Use the pre built image

The pre built image can be downloaded using Docker.

    $ docker pull TODO/hitch


### Build the docker image by yourself

You can also adjust and build the image according to your needs. Just clone the repository and then execute the build command.

    $ docker build -t hitch .


### Start the container

The container has all pre requisites to run Hitch. In case you do not provide your own SSL certificate it will create its own self-signed SSL certificate on first startup according to the [Hitch documentation](https://github.com/varnish/hitch/blob/master/docs/certificates.md).

By default it will create a certificate for the domain `example.com`, you can override this by providing another name via environment variables. This is not very useful for production but you can start playing around with the image.

    $ sudo docker run -i -d -p 80 -e DOMAIN=myown.example.com TODO/hitch

Note that this alone won't be very useful as the default configuration points to a backend server like Varnish on localhost port 80. This will not work as there is no such server running in this image. Instead combine this image with an instance of a proxy like Varnish Cache. Link the proxy port to this image and point to the correct backend by adjusting the `--backend` option in `HITCH_PARAMS`.

_TODO add an example_

#### Start the container and keep control
The command above starts the container and runs it in foreground. You can get a console in this image by executing

    $ docker run -ti -p 443 - TODO/hitch /bin/bash

