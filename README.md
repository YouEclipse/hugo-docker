# hugo-docker
A Docker image for websites built by hugo


## How to use


### build image

```
docker build --rm -t hugo-docker .
```

### run container

```
docker run --name {container_name} -d -p {host_port}:80  hugo-docker
```