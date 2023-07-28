FROM	golang:1.14.3-buster AS krbuild
RUN	go get github.com/kryptco/kr ; echo 'ignore go install warning'
WORKDIR /go/src/github.com/kryptco/kr
RUN	make all

FROM	node:20-bookworm

RUN	apt update && apt install -y \
		awscli \
		curl \
		httpie \
		jq \
		less \
		locales \
		locales-all \
		man \
		neovim \
		python3 \
		python3-pip \
		python3-pynvim \
		rsync \
		silversearcher-ag \
		tmux \
		zip \
		zsh \
	&& rm -rf /var/lib/apt/lists/*

# install node for vim + nvim
WORKDIR /usr/local

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
RUN	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		./.oh-my-zsh/custom/themes/powerlevel10k

RUN	curl -fLo /home/dev/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
	/usr/bin/nvim +PlugInstall +UpdateRemotePlugins +qall
RUN	sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/' .zshrc

CMD     zsh
