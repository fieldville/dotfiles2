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

# ユーザーとグループをホストの UID/GID に合わせる
# ubuntu:24.04 には既定で uid=1000 の ubuntu ユーザーが存在するため、
# 新規作成ではなく既存ユーザーを目的の UID/GID へ付け替える
RUN set -eux; \
    # 目的の GID のグループを用意（無ければ作成） \
    if ! getent group "$USER_GID" >/dev/null 2>&1; then \
        groupadd --gid "$USER_GID" appgroup; \
    fi; \
    if getent passwd ubuntu >/dev/null 2>&1; then \
        # 既存 ubuntu ユーザーの UID を変更（目的 UID が他ユーザーに使われていれば解放） \
        if [ "$(id -u ubuntu)" != "$USER_UID" ]; then \
            existing_user="$(getent passwd "$USER_UID" | cut -d: -f1 || true)"; \
            if [ -n "$existing_user" ] && [ "$existing_user" != "ubuntu" ]; then \
                userdel "$existing_user"; \
            fi; \
            usermod --uid "$USER_UID" ubuntu; \
        fi; \
        usermod --gid "$USER_GID" ubuntu; \
    else \
        useradd --uid "$USER_UID" --gid "$USER_GID" -m ubuntu; \
    fi; \
    echo "ubuntu ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu; \
    chmod 0440 /etc/sudoers.d/ubuntu; \
    chown -R "$USER_UID:$USER_GID" /home/ubuntu

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
  curl -fsSLO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" && \
  tar -C /opt -xzf "nvim-linux-${NVIM_ARCH}.tar.gz" && \
  rm "nvim-linux-${NVIM_ARCH}.tar.gz" && \
  ln -s "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim

# lazygit のインストール
RUN LAZYGIT_VERSION=$(curl -fsS "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
  ARCH=$(uname -m) && \
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
    LG_ARCH="arm64"; \
  else \
    LG_ARCH="x86_64"; \
  fi && \
  curl -fsSLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz" && \
  tar -xf lazygit.tar.gz lazygit && \
  install lazygit /usr/local/bin && \
  rm lazygit lazygit.tar.gz

# fzf の最新版インストール
RUN FZF_VERSION=$(curl -fsS "https://api.github.com/repos/junegunn/fzf/releases/latest" | grep -Po '"tag_name": "v?\K[^"]*') && \
  ARCH=$(uname -m) && \
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
    FZF_ARCH="arm64"; \
  else \
    FZF_ARCH="amd64"; \
  fi && \
  curl -fsSLo fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${FZF_ARCH}.tar.gz" && \
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

# ビルドコンテキスト内のファイルを Neovim 設定ディレクトリへコピー
COPY --chown=$USER_UID:$USER_GID . /home/ubuntu/.config/nvim/

# プラグインの初期インストールを同期
RUN nvim --headless "+Lazy! sync" +qa

# Gitに任意のディレクトリを信頼させる設定を追加
RUN git config --global --add safe.directory "*"

# docker run -u で任意の UID (ホストのユーザー) として起動されても
# $HOME (/home/ubuntu) 配下の nvim データ/状態/キャッシュに書き込めるよう権限を開放
RUN mkdir -p /home/ubuntu/.local/share/nvim \
             /home/ubuntu/.local/state/nvim \
             /home/ubuntu/.cache/nvim \
  && chmod -R 777 /home/ubuntu

# Neovimを起動
CMD ["nvim"]
