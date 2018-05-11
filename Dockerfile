FROM alpine:3.7

# Install packages, chmod startup script and add a non-privileged user
RUN apk --no-cache add git openssh-client \
                && adduser -D -u 1000 non-privileged \
                && mkdir /git \
                && chown -R 1000:1000 /git

# Switch to the non-privileged user
USER 1000

VOLUME /git
WORKDIR /git

ENTRYPOINT [ "sh", "-c" ]

# Overwrite as necessary NB: command must be passed as a single string
CMD [ "git clone ${GIT_REPO_URL} /git" ]
