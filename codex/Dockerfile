# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME=dev
ARG USER_UID=1001
ARG USER_GID=1001
ARG TARGETARCH

# ---- Basverktyg ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget gnupg lsb-release \
    git neovim zsh less unzip zip \
    build-essential make pkg-config \
    openssh-client \
    python3 python3-pip python3-venv \
    jq httpie silversearcher-ag \
    golang-go \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# ---- Azure CLI (via Microsoft apt repo) ----
RUN set -eux; \
    install -m 0755 -d /etc/apt/keyrings; \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg; \
    chmod go+r /etc/apt/keyrings/microsoft.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" \
      > /etc/apt/sources.list.d/azure-cli.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends azure-cli; \
    rm -rf /var/lib/apt/lists/*; \
    az version

# ---- AWS CLI v2 (official installer, multi-arch) ----
RUN set -eux; \
    case "${TARGETARCH}" in \
      "amd64") AWS_ARCH="x86_64" ;; \
      "arm64") AWS_ARCH="aarch64" ;; \
      *) echo "Unsupported TARGETARCH=${TARGETARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o /tmp/awscliv2.zip; \
    unzip -q /tmp/awscliv2.zip -d /tmp; \
    /tmp/aws/install; \
    rm -rf /tmp/aws /tmp/awscliv2.zip; \
    aws --version

# ---- Node.js (via NodeSource) ----
# (Ubuntu 24.04 kan ligga efter i apt; NodeSource ger modern LTS)
RUN set -eux; \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -; \
    apt-get update; \
    apt-get install -y --no-install-recommends nodejs; \
    rm -rf /var/lib/apt/lists/*; \
    node --version; npm --version

# ---- Terraform (via HashiCorp apt repo) ----
RUN set -eux; \
    install -m 0755 -d /etc/apt/keyrings; \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg; \
    echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
      > /etc/apt/sources.list.d/hashicorp.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends terraform; \
    rm -rf /var/lib/apt/lists/*; \
    terraform -version

# ---- Scala + sbt via Coursier (multi-arch, raw/master) ----
ENV COURSIER_HOME=/opt/coursier
ENV PATH="${COURSIER_HOME}/bin:${PATH}"

RUN set -eux; \
    case "${TARGETARCH}" in \
      "amd64") CS_URL="https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" ;; \
      "arm64") CS_URL="https://github.com/coursier/launchers/raw/master/cs-aarch64-pc-linux.gz" ;; \
      *) echo "Unsupported TARGETARCH=${TARGETARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL "${CS_URL}" | gunzip -c > /usr/local/bin/cs; \
    chmod +x /usr/local/bin/cs; \
    mkdir -p "${COURSIER_HOME}/bin"; \
    COURSIER_NO_PROMPT=1 cs install scala sbt --install-dir "${COURSIER_HOME}/bin"; \
    scala -version; sbt --version

# ---- Codex CLI (OpenAI) ----
# Officiell installation: npm i -g @openai/codex och kör "codex"
RUN set -eux; \
    npm i -g @openai/codex@latest; \
    codex --help >/dev/null || true

# ---- Skapa icke-root användare ----
RUN set -eux; \
    if ! getent group ${USER_GID} >/dev/null; then \
      groupadd --gid ${USER_GID} ${USERNAME}; \
    else \
      EXISTING_GROUP="$(getent group ${USER_GID} | cut -d: -f1)"; \
      echo "GID ${USER_GID} already exists as group ${EXISTING_GROUP}"; \
    fi; \
    if ! id -u ${USERNAME} >/dev/null 2>&1; then \
      useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}; \
    fi; \
    mkdir -p /workspace; \
    chown -R ${USER_UID}:${USER_GID} /workspace; \
    usermod --shell /usr/bin/zsh ${USERNAME}

WORKDIR /workspace
USER ${USERNAME}

# ---- Oh My Zsh + Powerlevel10k ----
RUN set -eux; \
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh"; \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"; \
    cp "${HOME}/.oh-my-zsh/templates/zshrc.zsh-template" "${HOME}/.zshrc"; \
    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "${HOME}/.zshrc"; \
    printf '\n[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh\n' >> "${HOME}/.zshrc"; \
    cat > "${HOME}/.p10k.zsh" <<'EOF'
# Minimal Powerlevel10k config for container shells.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs prompt_char)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)
typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
typeset -g POWERLEVEL9K_DIR_FOREGROUND=45
EOF

# Lite default ergonomi
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

CMD ["/usr/bin/zsh", "-l"]
