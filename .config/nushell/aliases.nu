# Clear
alias cls = clear

# Neofetch
alias nf = neofetch

# Goto ~
alias cdh = cd ~

# List All Files
alias ll = ls --all

# Run apt as superuser
alias sapt = sudo apt

# Run snap as superuser
alias ssnap = sudo snap 

# Open NixOS config using lapce
alias nixosconf = sudo lapce /etc/nixos/configuration.nix

# Reload awesome
alias awm-reload = awesome-client "awesome.restart()"

# Automatically reload awesome
def   awm-autoreload [] { find ~/.config/awesome/ | entr -p bash awesome-client "awesome.restart()"}

# Find files using ripgrep
def   rgfind [file] { rg --files -. --no-messages | rg -S $file }