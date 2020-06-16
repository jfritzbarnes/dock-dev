FROM	golang:1.14.3-buster AS krbuild
RUN	go get github.com/kryptco/kr ; echo 'ignore go install warning'
WORKDIR /go/src/github.com/kryptco/kr
RUN	make all

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

# install node for vim + nvim
WORKDIR /usr/local
RUN     curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage && \
        chmod u+x nvim.appimage && \
        ./nvim.appimage --appimage-extract && \
        find /usr/local/squashfs-root -type d -exec chmod 755 {} ';'

# set to swedish
ENV	LC_ALL=sv_SE.UTF-8
ENV	LANG=sv_SE.UTF-8
ENV	LANGUAGE=sv_SE.UTF-8

# copy krypton
COPY	--from=krbuild /go/src/github.com/kryptco/kr/bin/ /usr/bin/

RUN	userdel node && useradd -ms /bin/zsh -ou 1000 dev
USER	dev
WORKDIR /home/dev

RUN	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY    --chown=dev ./devhome/ /home/dev

RUN	curl -fLo /home/dev/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
	/usr/local/squashfs-root/usr/bin/nvim +PlugInstall +UpdateRemotePlugins +qall

CMD     zsh
