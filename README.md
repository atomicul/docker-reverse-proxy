# Docker Reverse Proxy

HTTP reverse proxy to route traffic with respect to the URI prefix. This can come in
handy in a container network, such as the one Docker Compose creates by default,
to expose multiple HTTP services under a single socket address (i.e., an ip-port pair).

## Usage
This docker container expects one command line argument per prefix mapped. Each
argument must be a whitespace separated pair in the form of `<prefix> <addess>`.
For example,given the command:
```
docker run -p 3000:80 ghcr.io/atomicul/docker-reverse-proxy:${IMAGE_VERSION} '/ http://host1' '/a/b/ http://host2'
```
The following forwarding happens:
* `http://localhost:3000/` -> `http://host1/`
* `http://localhost:3000/a/` -> `http://host1/a/`
* `http://localhost:3000/a/b/` -> `http://host2/`
* `http://localhost:3000/a/b/c/` -> `http://host2/c/`

You can find an example in `compose.yml`.

## Debugging & Tweaking
You can view logs by mounting `/logs`.

You can edit the nginx configuration by mounting `/config`.
