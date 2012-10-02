#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export LESS="-R"
export EDITOR="gvim"
export LANG="en_US.UTF-8"
export LOCALE="en_US.UTF-8"
export TZ="Asia/Jerusalem"
PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
export PATH="$PATH:/usr/bin/core_perl/:/opt/:~/.scripts//"
export HISTCONTROL=ignoredups
export HISTSIZE=1000


#COLORS for PS1 Prompt!
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\[\e[0;30m\]'        # Black
Red='\[\e[0;31m\]'          # Red
Green='\[\e[0;32m\]'        # Green
Yellow='\[\e[0;33m\]'       # Yellow
Blue='\[\e[0;34m\]'         # Blue
Purple='\[\e[0;35m\]'       # Purple
Cyan='\[\e[0;36m\]'         # Cyan
White='\[\e[0;37m\]'        # White

# High Intensty
IBlack='\[\e[0;90m\]'       # Black
IRed='\[\e[0;91m\]'         # Red
IGreen='\[\e[0;92m\]'       # Green
IYellow='\[\e[0;93m\]'      # Yellow
IBlue='\[\e[0;94m\]'        # Blue
IPurple='\[\e[0;95m\]'      # Purple
ICyan='\[\e[0;96m\]'        # Cyan
IWhite='\[\e[0;97m\]'       # White

#PS1='[\u@\h \W]\$ '
#PS1="$Green[\u@\h \W]\$ "
prompt_command () {
    local rts=$?
    local w=$(echo "${PWD/#$HOME/~}" | sed 's/.*\/\(.*\/.*\/.*\)$/\1/') # pwd max depth 3
# pwd max length L, prefix shortened pwd with m
    local L=30 m='<'
    [ ${#w} -gt $L ] && { local n=$((${#w} - $L + ${#m}))
    local w="\[\033[0;32m\]${m}\[\033[0;37m\]${w:$n}\[\033[0m\]" ; } \
    ||   local w="\[\033[0;37m\]${w}\[\033[0m\]"
# different colors for different return status
    [ $rts -eq 0 ] && \
    local p="\[\033[1;30m\]>\[\033[0;32m\]>\[\033[1;32m\]>\[\033[m\]" || \
    local p="\[\033[1;30m\]>\[\033[0;31m\]>\[\033[1;31m\]>\[\033[m\]"
    PS1="${w} ${p} "
}
PROMPT_COMMAND=prompt_command

#PATH="/opt/NX/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:~/.scripts//:/opt/:"

if [ -n "$DISPLAY" ]; then
     BROWSER=chromium
fi

# Pacman alias examples
alias pacman='pacman-color'
alias pacupg='sudo pacman-color -Syu'        # Synchronize with repositories before upgrading packages that are out of date on the local system.
alias pacins='sudo pacman-color -S'           # Install specific package(s) from the repositories
alias pacin='sudo pacman-color -U'          # Install specific package not from the repositories but from a file 
alias pacre='sudo pacman-color -R'           # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacrem='sudo pacman-color -Rns'        # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacrep='pacman-color -Si'              # Display information about a given package in the repositories
alias pacreps='pacman-color -Ss'             # Search for package(s) in the repositories
alias pacloc='pacman-color -Qi'              # Display information about a given package in the local database
alias paclocs='pacman-color -Qs'             # Search for package(s) in the local database
# Additional pacman alias examples
alias pacinsd='sudo pacman-color -S --asdeps'        # Install given package(s) as dependencies of another package
alias pacmir='sudo pacman-color -Syy'                # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

alias builds='cd ~/.builds'

# Alias some common commands to useful flags
alias ls='ls --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -lh --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias grep='grep --color=auto'

eval $(dircolors -b)

# CLI Print Aliases
alias pe='lp -o outputorder=reverse -o page-set=even -o fitplot -o medium=8.5x11in'
alias po='lp -o outputorder=normal -o page-set=odd -o fitplot -o medium=8.5x11in'

# Additional aliases
alias poweroff='sudo poweroff'
alias halt='sudo halt'
alias shutdown='sudo shutdown'
alias reboot='sudo reboot'

TEXINPUTS=/home/ron/texmf/latex/pgfplots//:/home/ron/texmf/latex/gnuplot-lua-tikz//:
