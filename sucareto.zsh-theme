# 修改 https://github.com/ChesterYue/ohmyzsh-theme-passion

# 自动安装插件，处理完成后会注释掉
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions $ZSH/custom/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH/custom/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH/custom/plugins/zsh-syntax-highlighting
sed -i 's/plugins=(git)/plugins=(\ngit\nzsh-autosuggestions\nzsh-completions\nzsh-history-substring-search\nzsh-syntax-highlighting\n)/' ~/.zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="sucareto"/' ~/.zshrc
sed -i '4,10s/^/# /' $ZSH/custom/themes/sucareto.zsh-theme && exit

# time
function real_time() {
    local color="%{$fg_no_bold[cyan]%}" # color in PROMPT need format in %{XXX%} which is not same with echo
    local time="[$(date +%H:%M:%S)]"
    local color_reset="%{$reset_color%}"
    echo "${color}${time}${color_reset}"
}

# directory
function directory() {
    local color="%{$fg_no_bold[cyan]%}"
    # REF: https://stackoverflow.com/questions/25944006/bash-current-working-directory-with-replacing-path-to-home-folder
    local directory="${PWD/#$HOME/~}"
    local color_reset="%{$reset_color%}"
    echo "${color}[${directory}]${color_reset}"
}

# git
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[blue]%}git(%{$fg_no_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_no_bold[blue]%}) 🔥"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_no_bold[blue]%})"

function update_git_status() {
    GIT_STATUS=$(git_prompt_info)
}

function git_status() {
    echo "${GIT_STATUS}"
}

# output command execute after
output_command_execute_after() {
    if [ "$COMMAND_TIME_BEIGIN" = "-20200325" ] || [ "$COMMAND_TIME_BEIGIN" = "" ]; then
        return 1
    fi

    # command_status
    local command_status
    if [ "$1" = "0" ]; then
        command_status="$fg_no_bold[green]($1)"
    else
        command_status="$fg_no_bold[red]($1)"
    fi

    # cost
    local time_end="$(current_time_millis)"
    local cost=$(bc -l <<<"${time_end}-${COMMAND_TIME_BEIGIN}")
    COMMAND_TIME_BEIGIN="-20200325"
    local length_cost=${#cost}
    if [ "$length_cost" = "4" ]; then
        cost="0${cost}"
    fi
    cost="$fg_no_bold[yellow][${cost}s]"

    printf "%${COLUMNS}s\n" "${command_status} ${cost}${color_reset}"
    #echo -e "\t\t${cost}${color_reset} ${command_status} "
}

# command execute before
# REF: http://zsh.sourceforge.net/Doc/Release/Functions.html
preexec() {
    COMMAND_TIME_BEIGIN="$(current_time_millis)"
}

current_time_millis() {
    local time_millis
    time_millis="$(date +%s.%3N)"
    echo $time_millis
}

# command execute after
# REF: http://zsh.sourceforge.net/Doc/Release/Functions.html
precmd() {
    # last_cmd
    output_command_execute_after $?

    # update_git_status
    update_git_status
}

# set option
setopt PROMPT_SUBST

# timer
#REF: https://stackoverflow.com/questions/26526175/zsh-menu-completion-causes-problems-after-zle-reset-prompt
TMOUT=1
TRAPALRM() {
    # $(git_prompt_info) cost too much time which will raise stutters when inputting. so we need to disable it in this occurence.
    # if [ "$WIDGET" != "expand-or-complete" ] && [ "$WIDGET" != "self-insert" ] && [ "$WIDGET" != "backward-delete-char" ]; then
    # black list will not enum it completely. even some pipe broken will appear.
    # so we just put a white list here.
    if [ "$WIDGET" = "" ] || [ "$WIDGET" = "accept-line" ]; then
        zle reset-prompt
    fi
}

# prompt
PROMPT='$(real_time) $(directory) $(git_status) '

function ipls(){
        ip -4 addr show $* | grep inet | awk '{print $2}'
}
