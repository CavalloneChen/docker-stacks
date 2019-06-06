source ~/antigen.zsh

antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# theme
antigen theme denysdovhan/spaceship-prompt
#SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_HOST_SHOW=false
SPACESHIP_USER_COLOR=cyan
SPACESHIP_DIR_COLOR=blue

antigen apply