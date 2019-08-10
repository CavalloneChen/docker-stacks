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
