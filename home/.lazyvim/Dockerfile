FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:${PATH}"

# 必要な基本パッケージおよびLazyVimの依存関係をインストール
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

# CPUアーキテクチャ（x86_64 / arm64）に合わせて最適なNeovimをセットアップ
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

# LazyVim Starterをクローン
RUN git clone https://github.com/LazyVim/starter /root/.config/nvim \
  && rm -rf /root/.config/nvim/.git

# ローカルのカスタム設定（luaディレクトリ）をイメージ内にコピー
COPY lua /root/.config/nvim/lua

# プラグインの初期インストールを同期
RUN nvim --headless "+Lazy! sync" +qa

# 作業ディレクトリの設定
WORKDIR /workspace

# Neovimを起動
CMD ["nvim"]
