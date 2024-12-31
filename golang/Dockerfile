FROM	golang:1.14.3-buster AS krbuild
RUN	go get github.com/kryptco/kr ; echo 'ignore go install warning'
WORKDIR	/go/src/github.com/kryptco/kr
RUN	make all

FROM	golang:1.23-bookworm

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
		zsh

# copy krypton
COPY --from=krbuild /go/src/github.com/kryptco/kr/bin/ /usr/bin/

# set to swedish
ENV	LC_ALL=sv_SE.UTF-8
ENV	LANG=sv_SE.UTF-8
ENV	LANGUAGE=sv_SE.UTF-8

# install node for vim + nvim
WORKDIR /usr/local
RUN	curl -sL install-node.now.sh/lts > /tmp/node.sh && \
	chmod u+x /tmp/node.sh && \
	/tmp/node.sh --yes && \
	npm install --global yarn

#	curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage && \
#	chmod u+x nvim.appimage && \
#	./nvim.appimage --appimage-extract && \
#	find /usr/local/squashfs-root -type d -exec chmod 755 {} ';'

RUN	useradd -ms /bin/zsh dev
USER	dev
WORKDIR /home/dev

RUN	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY	--chown=dev ./devhome/ /home/dev/
RUN	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ./.oh-my-zsh/custom/themes/powerlevel10k

RUN	curl -fLo /home/dev/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
	/usr/bin/nvim +PlugInstal +UpdateRemotePlugins +qall

CMD	zsh
