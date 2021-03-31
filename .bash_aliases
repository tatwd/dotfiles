alias ..='cd ..'
alias ...='cd ../..'
alias gits='git status'
alias gitc='git commit'
#alias s='screenfetch'
alias s='neofetch'
alias u='sudo apt update'
alias appadd='sudo apt install'
alias up='sudo apt upgrade'
alias uup='sudo apt update && sudo apt upgrade'
alias autorm='sudo apt autoremove'
alias cdblog='cd ~/works/tatwd.github.io'
alias lsdc='docker container ls'
alias dps='docker ps'
alias dob='dotnet build'
alias dor='dotnet run'
alias open='xdg-open'

#hexdump view with text
function hdv {
  hexdump -e '16/1 "%02X " " | "' -e '16/1 "%_p" "\n"' $1
}
