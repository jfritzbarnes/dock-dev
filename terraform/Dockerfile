FROM	hashicorp/terraform:0.15.3 as terraform

FROM	node:12.18.0-buster

RUN	apt update && apt install -y \
                jq \
                less \
                locales \
                locales-all \
                man \
                python3 \
                python3-pip \
                rsync \
                zip \
                zsh \
        && rm -rf /var/lib/apt/lists/*
RUN     pip3 install pynvim httpie awscli

# set to swedish
ENV	LC_ALL=sv_SE.UTF-8
ENV	LANG=sv_SE.UTF-8
ENV	LANGUAGE=sv_SE.UTF-8

COPY	--from=terraform /bin/terraform /bin/terraform

RUN	wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.29.3/terragrunt_linux_amd64 -O /bin/terragrunt && \
	chmod +x /bin/terragrunt

RUN	userdel node && useradd -ms /bin/zsh -ou 1000 dev
USER	dev
WORKDIR /home/dev

RUN     sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY    --chown=dev ./devhome/ /home/dev

CMD	zsh
