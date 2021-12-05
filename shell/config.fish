#!/bin/bash
function fish_prompt
	echo -en "\033[33m"
        echo -n (prompt_pwd)
	echo -e "\033[0m"
	echo -e "\033[1;36m -> \033[0m"
end

function fish_title
	echo "Terminal"
end

function fish_greeting
	echo -e "\033[4;34m Talk is cheap. Show me the code. \033[0m"
end

function ipls
	ip -4 addr show $argv | grep inet | awk '{print $2}'
end

set -x PATH $PATH ~/.local/bin