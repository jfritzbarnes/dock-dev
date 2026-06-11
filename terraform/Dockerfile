ARG	TERRAFORM_VERSION=1.15.4
ARG	TERRAGRUNT_VERSION=1.0.5

FROM	hashicorp/terraform:${TERRAFORM_VERSION} AS terraform

FROM	node:24-trixie
ARG	TERRAGRUNT_VERSION=1.0.5

RUN	apt update && apt install -y \
                awscli \
                azure-cli \
                curl \
                httpie \
                jq \
                less \
                locales \
                locales-all \
                man \
                python3 \
                python3-pip \
                python3-pynvim \
                rsync \
                zip \
                zsh \
        && rm -rf /var/lib/apt/lists/*

# set to swedish
ENV	LC_ALL=sv_SE.UTF-8
ENV	LANG=sv_SE.UTF-8
ENV	LANGUAGE=sv_SE.UTF-8

COPY	--from=terraform /bin/terraform /usr/local/bin/terraform

RUN	set -eux; \
	case "$(dpkg --print-architecture)" in \
		amd64) TERRAGRUNT_ARCH="amd64" ;; \
		arm64) TERRAGRUNT_ARCH="arm64" ;; \
		*) echo "Unsupported architecture: $(dpkg --print-architecture)"; exit 1 ;; \
	esac; \
	curl -fsSL "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${TERRAGRUNT_ARCH}" \
		-o /usr/local/bin/terragrunt; \
	chmod +x /usr/local/bin/terragrunt; \
	terraform -version; \
	terragrunt --version

RUN	userdel node && useradd -ms /bin/zsh -ou 1000 dev
USER	dev
WORKDIR /home/dev

RUN     sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY    --chown=dev ./devhome/ /home/dev

CMD	zsh
