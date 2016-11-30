FROM    node:6.5.0

# setup to install basic development environment
RUN     apt-get update && apt-get upgrade -y
RUN     apt-get install -y less man vim jq httpie

# setup to install AWS CLI
RUN     apt-get install -y python python-pip python-virtualenv
RUN     pip install awscli

WORKDIR /devel

