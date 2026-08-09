FROM ubuntu:24.04

# ビルド引数の定義（デフォルト 1000）
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive

# 1. 日本語ロケール（ja_JP.UTF-8）の生成と環境変数の設定
RUN apt-get update && apt-get install -y locales && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8

# PATHの設定
ENV PATH="/root/.local/bin:/root/.cargo/bin:${PATH}"

# 2. 必要な基本パッケージおよびLazyVim / Masonの依存関係をインストール
RUN apt-get update && apt-get install -y \
  curl \
  git \
  build-essential \
  unzip \
  zip \
  ripgrep \
  fd-find \
  nodejs \
  npm \
  python3 \
  python3-pip \
  golang \
  python3.12-venv \
  php-cli \
  php-xml \
  php-mbstring \
  php-curl \
  php-zip \
  composer \
  luarocks \
  ruby \
  ruby-dev \
  netcat-openbsd \
  sudo \
  && rm -rf /var/lib/apt/lists/*

# ユーザーとグループの作成
RUN if ! getent group $USER_GID >/dev/null 2>&1; then \
        groupadd --gid $USER_GID $USERNAME; \
    fi && \
    if ! getent passwd $USER_UID >/dev/null 2>&1; then \
        useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    else \
        # 既存ユーザー（ubuntu等）が存在する場合、そのユーザー名を取得してUSERNAMEを更新
        USERNAME=$(getent passwd $USER_UID | cut -d: -f1); \
    fi && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# fdfindをfdとして使えるようにシンボリックリンクを作成
RUN ln -s /usr/bin/fdfind /usr/bin/fd

# tree-sitter CLI のインストール (npm 経由)
RUN npm install -g tree-sitter-cli

# 最新版の Rust (rustup/cargo) をインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# CPUアーキテクチャに合わせてNeovimをセットアップ
RUN ARCH=$(uname -m) && \
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
    NVIM_ARCH="arm64"; \
  else \
    NVIM_ARCH="x86_64"; \
  fi && \
  curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" && \
  tar -C /opt -xzf "nvim-linux-${NVIM_ARCH}.tar.gz" && \
  rm "nvim-linux-${NVIM_ARCH}.tar.gz" && \
  ln -s "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim

# lazygit のインストール
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
  ARCH=$(uname -m) && \
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
    LG_ARCH="arm64"; \
  else \
    LG_ARCH="x86_64"; \
  fi && \
  curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz" && \
  tar -xf lazygit.tar.gz lazygit && \
  install lazygit /usr/local/bin && \
  rm lazygit lazygit.tar.gz

# fzf の最新版インストール
RUN FZF_VERSION=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" | grep -Po '"tag_name": "v?\K[^"]*') && \
  ARCH=$(uname -m) && \
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
    FZF_ARCH="arm64"; \
  else \
    FZF_ARCH="amd64"; \
  fi && \
  curl -sLo fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${FZF_ARCH}.tar.gz" && \
  tar -xf fzf.tar.gz fzf && \
  install fzf /usr/local/bin && \
  rm fzf fzf.tar.gz

# 作成（または既存の）一般ユーザーに切り替え
USER $USER_UID
WORKDIR /workspace

# PATH の設定（一般ユーザー用）
ENV PATH="/home/ubuntu/.local/bin:/home/ubuntu/.cargo/bin:${PATH}"

# LazyVim Starterを一般ユーザーのホームディレクトリにクローン
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim \
  && rm -rf ~/.config/nvim/.git

# ローカルのカスタム設定（luaディレクトリ）をコピー
COPY --chown=$USER_UID:$USER_GID lua ~/.config/nvim/lua

# プラグインの初期インストールを同期
RUN nvim --headless "+Lazy! sync" +qa

# Gitに任意のディレクトリを信頼させる設定を追加
RUN git config --global --add safe.directory "*"

# Neovimを起動
CMD ["nvim"]
