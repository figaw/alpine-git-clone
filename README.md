# Git alpine

Minimal alpine image, that can interact with git

# Build

```
docker build -t alpine-git .
```

# Run
Create a `keys` folder, containing your private `id_rsa` ssh-key
and a `known_hosts` file for the Git server you're interacting with,
and mount it to the `.ssh` folder of the `non-privileged`-user

Create a `git` folder and mount it into the `/git` path.

Pass the repository url as the `GIT_REPO_URL` environment variable.

```
docker run --rm \
    -e GIT_REPO_URL="git@bitbucket.org:myteam/myproject.git" \
    -v $PWD/keys:/home/non-privileged/.ssh \
    -v $PWD/git:/git \
    alpine-git [-- <optional command>]
```

Where `[-- <optional parameter>]` could be `-- git checkout my-branch` or `--version`
(the preceding `--` aren't necessary when it's only a single command.)

# Testing
Generate ssh-keys with `ssh-keygen -q -t rsa -N '' -f id_rsa`, and put the private-key into the `keys` directory.

Add a `known_hosts` file as well, using `ssh-keyscan bitbucket.org`
(you can run this in an alpine image as well, after installing `openssh-client`)

# Why?

The official `alpine/git` uses the `git` command as the `ENTRYPOINT`, but it doesn't unfold environment variables; `sh` does.

A single string? I haven't had luck specifying it as either,

```
ENTRYPOINT [ 'sh', '-c' 'git' ]
CMD [ 'clone', '$GIT_REPO_URL',  ]
```
or
```
ENTRYPOINT [ 'sh', '-c' ]
CMD [ 'git', 'clone', '$GIT_REPO_URL',  ]
```
