FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:${PATH}"

# 必要な基本パッケージおよびLazyVimの依存関係（ripgrep, fd, build-essential等）をインストール
RUN apt-get update && apt-get install -y \
  curl \
  git \
  build-essential \
  unzip \
  ripgrep \
  fd-find \
  nodejs \
  npm \
  python3 \
  python3-pip \
  golang \
  && rm -rf /var/lib/apt/lists/*

# fdfindをfdとして使えるようにシンボリックリンクを作成
RUN ln -s /usr/bin/fdfind /usr/bin/fd

# 最新版のNeovim（Tarball）をセットアップ
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
  && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
  && rm nvim-linux-x86_64.tar.gz
ENV PATH="/opt/nvim-linux-x86_64/bin:${PATH}"

# LazyVim Starterをクローン
RUN git clone https://github.com/LazyVim/starter /root/.config/nvim \
  && rm -rf /root/.config/nvim/.git

# ローカルのカスタム設定（luaディレクトリ）をイメージ内にコピー
COPY lua /root/.config/nvim/lua

# プラグインの初期インストールを完全同期（Mason等の事前準備含む）
RUN nvim --headless "+Lazy! sync" +qa

# 作業ディレクトリの設定
WORKDIR /workspace

# Neovimを起動
CMD ["nvim"]
