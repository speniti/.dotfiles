use std/util "path add"

$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

alias ll = ls -l
alias la = ls -la
alias vim = nvim

path add "~/.local/bin"
path add "~/.luarocks/bin/"
path add "~/.composer/vendor/bin/"
path add "~/.npm/bin/"

if ($env.TERMINAL_EMULATOR? == "JetBrains-JediTerm") {
    $env.STARSHIP_CONFIG = $"($env.HOME)/.config/jetbrains.toml"
}
