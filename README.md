# Mockly - Tiny API Mock Server

Mockly is a small, file-based API mock server for local testing. It is
designed to allow replacing an API server when testing any tool that uses a
JSON API.

Configuring endpoints is done by placing JSON files in a simple directory
structure.

## Install

```shell
$ gem install mockly
```

## Docker Image

Mockly is also available as a [docker image][docker]:

```shell
# Pull the image
$ docker pull dannyben/mockly

# Run the mockly command line
$ docker run --rm -it dannyben/mockly --help

# Start the server
$ docker run --rm -it \
    -p 3000:3000 \
    -v $PWD/mocks:/app/mocks \
    dannyben/mockly
```

### Using with docker-compose

```yaml
# docker-compose.yml
services:
  web:
    image: dannyben/mockly
    volumes:
      - ./spec/fixtures/mocks:/app/mocks
    ports:
      - 3000:3000

```

### Using as an alias

```shell
$ alias mockly='docker run --rm -it -p 3000:3000 -v $PWD/mocks:/app/mocks dannyben/mockly'
```

## Directory Structure

Mocks live under a single `mocks/` folder. For a request path, Mockly looks
for JSON files in this order (first match wins):

1. `mocks/<dir>/<method>-<name>.json`
2. `mocks/<dir>/<name>/<method>.json`
3. `mocks/<dir>/<name>.json`

Quick diagram:

```
mocks/
  get.json
  get-users.json
  users/
    get.json
    post.json
  chat/
    completions.json
  assets/
    image.jpg
```

Examples:

- `GET /` → `mocks/get.json`
- `GET /users` → `mocks/get-users.json` (or `mocks/users/get.json`, or `mocks/users.json`)
- `POST /users` → `mocks/post-users.json` (or `mocks/users/post.json`, or `mocks/users.json`)
- `GET /chat/completions` → `mocks/chat/completions.json`

Static files are also supported: if an exact file exists under `mocks/`, it is
served as-is (e.g. `GET /assets/image.jpg` → `mocks/assets/image.jpg`).


## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].


---

[issues]: https://github.com/DannyBen/mockly/issues
[docker]: https://hub.docker.com/r/dannyben/mockly
