# stretcd

*str-etcd* stress out your etcd cluster

## About
stretcd will populate keys of an specified size into the namespace 
`/stretcd/`.

It is important to keep in mind that the ETCD_SERVER address needs to be addressable from the container.  Generally it's most expedient to use the Docker bridge address (if Docker is being used at `172.17.42.1`.

## Usage

Spawn the container and supply the 2 required options:

  * ETCD_ACTION - one of "populate" or "destroy"
  * ETCD_SERVER - the tcp address of the server (ex: 172.17.42.1:4001)

Additionally, if the server is being populated supply the following two options 
  * STRECTD_KEYS - the total number of keys to populate
  * STRETCD_SIZE - the size of each key in bytes

## Examples

### Populating a cluster with values

```
$ docker run --rm -e ETCD_SERVER=172.17.42.1:4001 -e ETCD_ACTION=populate -e STRETCD_KEYS=100 -e STRETCD_SIZE=1024  quay.io/brianredbeard/stretcd
```

### Clearing values from a cluster

```
$ docker run --rm -e ETCD_SERVER=172.17.42.1:4001 -e ETCD_ACTION=destroy quay.io/brianredbeard/stretcd
```


## Building

Perform some variation on:

```
$ git pull https://github.com/brianredbeard/stretcd.git
$ cd stretcd
$ docker build .
```

