# Docker4Ansible Notes

## It's a trap!! Windows CRLF will mess you up.

Either set your editor to save in LF line termination, or keep this one-liner handy:

```
perl -pi -e 's/\r\n/\n/g *'
```

And, you'll need it because _git add_ saved everything with host line terminations, meaning all the hard work that went into changing *CRLF to LF is gone*.

### Look at .gitattributes

Try changing git's default line ending behavior with this:

```
* text=lf
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

## Add to ~/.bashrc

```
eval "$(docker-machine env machine-name)"
```

Don't forget to revisit this if you change your docker-machine. Also, best to start a new shell after creating the machine.
