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
alias scap='ffmpeg -f x11grab -framerate 25 -video_size 1366*768 -i :0.0 -f alsa -ac 2 -i default'

#hexdump view with text
function hdv {
  hexdump -e '16/1 "%02X " " | "' -e '16/1 "%_p" "\n"' $1
}


#from https://gitlab.com/islandoftex/images/texlive/-/wikis/Building-LaTeX-documents-locally-using-Docker
alias tlrun='sudo docker run -i --rm --name latex -v "$PWD":/usr/src/app -w /usr/src/app registry.gitlab.com/islandoftex/images/texlive:latest'
alias arara='sudo docker run -i --rm --name latex -v "$PWD":/usr/src/app -w /usr/src/app registry.gitlab.com/islandoftex/images/texlive:latest arara'
alias pdflatex='sudo docker run -i --rm --name latex -v "$PWD":/usr/src/app -w /usr/src/app registry.gitlab.com/islandoftex/images/texlive:latest pdflatex'

myhttp_proxy="http://127.0.0.1:7890"
alias gph='git config --global http.proxy $myhttp_proxy'
alias nogph='git config --global --unset http.proxy'
alias gphs='git config --global https.proxy $myhttp_proxy'
alias nogphs='git config --global --unset https.proxy'
alias nph='npm config set proxy $myhttp_proxy'
alias nonph='npm config delete proxy'
#unset myhttp_proxy
