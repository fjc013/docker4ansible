# Docker4Ansible Notes

## It's a trap!! Windows CRLF will mess you up.

Either set your editor to save in LF line termination, or keep this one-liner handy:

```
perl -pi -e 's/\r\n/\n/g *'
```

## Create a docker machine with the right driver

For windows use virtualbox:

```
docker-machine create --driver=virtualbox machine-name
```

Note the docker machine ip address. You'll need it for ~/.ssh/config

```
docker-machine ip machine-name
```
