FROM	golang:1.14.3-buster AS krbuild
RUN	go get github.com/kryptco/kr ; echo 'ignore go install warning'
WORKDIR	/go/src/github.com/kryptco/kr
RUN	make all

FROM	python:3.14-trixie
RUN	apt update && apt install -y \
		ca-certificates \
		curl \
		git \
		jq \
		less \
		locales \
		locales-all \
		man \
		rsync \
		silversearcher-ag \
		zip \
		zsh \
	&& rm -rf /var/lib/apt/lists/*
RUN	pip install --no-cache-dir httpie awscli pynvim jedi

# install nvim
RUN	set -eux; \
	case "$(dpkg --print-architecture)" in \
		amd64) NVIM_ARCH="x86_64" ;; \
		arm64) NVIM_ARCH="arm64" ;; \
		*) echo "Unsupported architecture: $(dpkg --print-architecture)"; exit 1 ;; \
	esac; \
	curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" \
		-o /tmp/nvim.tar.gz; \
	tar -xzf /tmp/nvim.tar.gz -C /opt; \
	mv "/opt/nvim-linux-${NVIM_ARCH}" /opt/nvim; \
	ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim; \
	rm /tmp/nvim.tar.gz; \
	nvim --version

# set to swedish
ENV	LC_ALL=sv_SE.UTF-8
ENV     LANG=sv_SE.UTF-8
ENV     LANGUAGE=sv_SE.UTF-8

# copy krypton
COPY	--from=krbuild /go/src/github.com/kryptco/kr/bin/ /usr/bin/

RUN	useradd -ms /bin/zsh -ou 1000 dev
USER	dev
WORKDIR	/home/dev

RUN     sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY    --chown=dev ./devhome/ /home/dev
RUN	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

RUN     curl -fLo /home/dev/.local/share/nvim/site/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
        /usr/local/bin/nvim +PlugInstall +UpdateRemotePlugins +qall

CMD     ["zsh"]
