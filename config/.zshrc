source ~/antigen.zsh

antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search

# theme
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
PURE_PROMPT_SYMBOL=ψ
zstyle :prompt:pure:git:branch color red
zstyle :prompt:pure:path color green
zstyle :prompt:pure:user color magenta
zstyle :prompt:pure:host color white
zstyle :prompt:pure:virtualenv color blue
zstyle ':prompt:pure:prompt:*' color blue

antigen apply

# aliases
alias vi="nvim"
alias ll="ls -la"

# functions
dsinfo(){
    local first_arg="$1"
    echo "Dir total size:"
    du -sh "$@"
    echo "\n"
    echo "Top 10 files/dirs:"
    du -ah "$@" | sort -hr | head -10
}

# linux brew
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# anti body
# source <(antibody init)
# antibody bundle < ~/.zsh_plugins.txt
