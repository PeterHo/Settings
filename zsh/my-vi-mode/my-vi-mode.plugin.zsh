# urxvt (and family) accepts even #RRGGBB
INSERT_PROMPT="green"
COMMAND_PROMPT="red"

# helper for setting color including all kinds of terminals
set_prompt_color() {
    if [[ $TERM = "linux" ]]; then
       # nothing
    elif [[ $TMUX != '' ]]; then
        printf '\033Ptmux;\033\033]12;%b\007\033\\' "$1"
    else
        echo -ne "\033]12;$1\007"
    fi
}

# change cursor color basing on vi mode
zle-keymap-select () {
    if [ $KEYMAP = vicmd ]; then
        set_prompt_color $COMMAND_PROMPT
    else
        set_prompt_color $INSERT_PROMPT
    fi
}

zle-line-finish() {
    set_prompt_color $INSERT_PROMPT
}

zle-line-init () {
    zle -K viins
    set_prompt_color $INSERT_PROMPT
}

zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish


bindkey -v

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi
