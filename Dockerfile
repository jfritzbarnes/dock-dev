FROM    node:6.10

# setup to install basic development environment
RUN     apt-get update && apt-get upgrade -y
RUN     apt-get install -y less man vim jq httpie

# setup to install AWS CLI
RUN     apt-get install -y python python-pip python-virtualenv python-dev
RUN     pip install awscli
# create symbolic links; requires use of secrets
RUN     mkdir ~/.aws && \
        ln -s /run/secrets/aws.config ~/.aws/config && \
        ln -s /run/secrets/aws.credentials ~/.aws/credentials

# setup angular development; allow for optional local npm registry
ARG     REGISTRY=registry.npmjs.org
RUN     npm set registry http://${REGISTRY}/
RUN     npm install -g @angular/cli
RUN     npm set registry http://registry:4873/

WORKDIR /devel
CMD     exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
