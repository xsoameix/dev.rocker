FROM archlinux
RUN groupadd -g 142 dev && \
  useradd -u 995 -g 142 -m -s /bin/bash dev && \
  pacman -Syy && \
  pacman -S --noconfirm ruby vim-minimal git openssh
USER dev
WORKDIR /home/dev
RUN mkdir .ssh && \
  chmod 700 .ssh && \
  touch .ssh/id_rsa && \
  touch .ssh/id_rsa.pub && \
  chmod 600 .ssh/id_rsa && \
  chmod 644 .ssh/id_rsa.pub && \
  mkdir -p .vim/autoload .vim/bundle && \
  curl -LSso .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
  echo $'TERM=xterm\n\
alias ls="ls --color=auto"\n\
alias grep="grep --colour=auto"\n\
PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "\n\
export PATH="$HOME/docker/rocker:$PATH"' > .bashrc && \
  echo $'set nocompatible\n\
execute pathogen#infect()\n\
syntax on\n\
filetype plugin indent on\n\
set smartindent\n\
setl sts=2 sw=2 et\n\
set tabstop=2\n\
set shiftwidth=2\n\
set expandtab\n\
set viminfo+=n~/.viminfo/viminfo' > .vimrc && \
  echo $'require "irb/completion"\n\
require "irb/ext/save-history"\n\
ARGV.concat %w(--readline --prompt-mode simple)\n\
IRB.conf[:SAVE_HISTORY] = 100\n\
IRB.conf[:HISTORY_FILE] = "#{ENV["HOME"]}/.irb-history"' > .irbrc && \
  git clone https://github.com/vim-ruby/vim-ruby.git .vim/bundle/bundle/vim-ruby
WORKDIR /home/dev/docker
