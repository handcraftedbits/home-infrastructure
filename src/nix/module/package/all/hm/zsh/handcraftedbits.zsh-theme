PROMPT='%{$FG[208]%}%n%{$reset_color%}@%{$FG[197]%}%m%{$reset_color%}:%{$FG[118]%}$(shrink_path -f)%{$reset_color%}$(git_prompt_info)%(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[081]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"