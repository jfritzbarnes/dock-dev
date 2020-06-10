# install krypton
FROM	golang:1.14.3-buster AS krbuild
RUN	go get github.com/kryptco/kr ; echo 'ignore go install warning'
WORKDIR /go/src/github.com/kryptco/kr
RUN	make all

FROM	openjdk:14.0.1-buster

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
	&& echo 'not complete'
#	&& rm -rf /var/lib/apt/lists/*
RUN	pip3 install pynvim awscli httpie

# copy krypton
COPY --from=krbuild /go/src/github.com/kryptco/kr/bin/ /usr/bin/

# set to swedish
ENV	LC_ALL=sv_SE.UTF-8
ENV	LANG=sv_SE.UTF-8
ENV	LANGUAGE=sv_SE.UTF-8

# install sbt & scala
ARG	SCALA_VERSION
ENV	SCALA_VERSION ${SCALA_VERSION:-2.13.2}
ARG	SBT_VERSION
ENV	SBT_VERSION ${SBT_VERSION:-1.3.10}

RUN	curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
		dpkg -i sbt-$SBT_VERSION.deb && \
		rm sbt-$SBT_VERSION.deb && \
		apt-get update && \
		apt-get install sbt && \
		curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | \
			tar xfz - -C /usr/share && \
		mv /usr/share/scala-$SCALA_VERSION /usr/share/scala && \
		chown -R root:root /usr/share/scala && \
		chmod -R 755 /usr/share/scala && \
		ln -s /usr/share/scala/bin/scala /usr/local/bin/scala

# build nvim; the buster nvim version is old so it is built from source
# instead. Include node.js for coc.nvim (Conquer of Completion)
#ENV	NVM_DIR="usr/local/nvm"
#RUN	mkdir "$NVM_DIR" && \
#		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
#		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install Erbium && \
#		curl -L https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
#			-o /tmp/nvim.appimage

# install node for vim; krypton; and nvim
WORKDIR /usr/local
RUN	curl -sL install-node.now.sh/lts > /tmp/node.sh && \
	chmod u+x /tmp/node.sh && \
	/tmp/node.sh --yes && \
	#curl --compressed -o- -L https://yarnpkg.com/install.sh | bash && \
	npm install --global yarn && \
	curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage && \
	chmod u+x nvim.appimage && \
	./nvim.appimage --appimage-extract && \
	find /usr/local/squashfs-root -type d -exec chmod 755 {} ';'

RUN	useradd -ms /bin/zsh dev
USER	dev
WORKDIR /home/dev

RUN	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY	--chown=dev ./devhome/ /home/dev/

RUN	curl -fLo /home/dev/.local/share/nvim/site/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# temporary so I can do root things
#USER	root
CMD	zsh
