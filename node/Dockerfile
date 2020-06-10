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
RUN	pip3 install pynvim httpie awscli

# set to swedish
ENV	LC_ALL=sv_SE.UTF-8
ENV	LANG=sv_SE.UTF-8
ENV	LANGUAGE=sv_SE.UTF-8

RUN	userdel node && useradd -ms /bin/zsh -ou 1000 dev
USER	dev
WORKDIR /home/dev

RUN	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

CMD     zsh
