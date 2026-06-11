FROM    node:24-trixie

# setup to install basic development environment
RUN     apt-get update && apt-get install -y --no-install-recommends \
        awscli \
        httpie \
        jq \
        less \
        locales \
        locales-all \
        man \
        python3 \
        python3-pip \
        python3-venv \
        rsync \
        vim \
        zip \
        && rm -rf /var/lib/apt/lists/*

# set to swedish :)
ENV     LC_ALL=sv_SE.UTF-8
ENV     LANG=sv_SE.UTF-8
ENV     LANGUAGE=sv_SE.UTF-8

# create symbolic links; requires use of secrets
RUN     mkdir -p ~/.aws && \
        ln -s /run/secrets/aws.config ~/.aws/config && \
        ln -s /run/secrets/aws.credentials ~/.aws/credentials

# setup angular development; allow for optional local npm registry
#ARG     REGISTRY=registry.npmjs.org
#RUN     npm set registry http://${REGISTRY}/
#RUN     npm install -g @angular/cli

WORKDIR /devel
CMD     exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
