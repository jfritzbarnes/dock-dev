FROM	golang:1.14.3-buster AS krbuild
RUN	go get github.com/kryptco/kr ; echo 'ignore go install warning'
WORKDIR /go/src/github.com/kryptco/kr
RUN	make all

FROM	eclipse-temurin:25-jdk

RUN	apt update && apt install -y \
		awscli \
		ca-certificates \
		curl \
		git \
		gnupg \
		gzip \
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
		zip \
		zsh \
	&& rm -rf /var/lib/apt/lists/*

# copy krypton
COPY --from=krbuild /go/src/github.com/kryptco/kr/bin/ /usr/bin/

# set to swedish
ENV	LC_ALL=sv_SE.UTF-8
ENV	LANG=sv_SE.UTF-8
ENV	LANGUAGE=sv_SE.UTF-8

# install sbt & scala via Coursier
ENV	COURSIER_HOME=/opt/coursier
ENV	COURSIER_CACHE=/opt/coursier/cache
ENV	PATH="${COURSIER_HOME}/bin:${PATH}"

RUN	set -eux; \
	case "$(dpkg --print-architecture)" in \
		amd64) CS_URL="https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" ;; \
		arm64) CS_URL="https://github.com/coursier/launchers/raw/master/cs-aarch64-pc-linux.gz" ;; \
		*) echo "Unsupported architecture: $(dpkg --print-architecture)"; exit 1 ;; \
	esac; \
	curl -fsSL "${CS_URL}" | gunzip -c > /usr/local/bin/cs; \
	chmod +x /usr/local/bin/cs; \
	mkdir -p "${COURSIER_HOME}/bin" "${COURSIER_CACHE}"; \
	COURSIER_NO_PROMPT=1 cs install scala sbt --install-dir "${COURSIER_HOME}/bin"; \
	chmod -R a+rX "${COURSIER_HOME}"; \
	scala -version; \
	sbt --script-version

# install node for vim
RUN	set -eux; \
	curl -fsSL https://deb.nodesource.com/setup_24.x | bash -; \
	apt-get update; \
	apt-get install -y --no-install-recommends nodejs; \
	rm -rf /var/lib/apt/lists/*; \
	npm install --global yarn; \
	node --version; \
	npm --version; \
	yarn --version

RUN	useradd -ms /bin/zsh dev
USER	dev
WORKDIR /home/dev

RUN	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY	--chown=dev ./devhome/ /home/dev/

RUN	curl -fLo /home/dev/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

CMD	zsh
