FROM ubuntu

# Install dependencies
RUN apt-get update -y && apt-get install -y curl git

# Install neovim
WORKDIR /tmp
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
RUN tar xzf nvim-linux64.tar.gz -C /opt
ENV PATH /opt/nvim-linux64/bin:$PATH

# Install essential neovim plugins
WORKDIR /root/.local/share/nvim/site/pack/hotpot.nvim/start
RUN git clone https://github.com/rktjmp/hotpot.nvim

# Deploy themis.nvim
COPY . /root/.local/share/nvim/site/pack/themis.nvim/start/themis.nvim

# Deploy test configuration
COPY test-config /root/.config/nvim

# Finish
WORKDIR /root/.config/nvim
