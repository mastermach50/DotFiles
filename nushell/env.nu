# Nushell Environment Config File
#
# version = 0.80.0

# Configured by Mathew

let-env EDITOR = nvim

def create_left_prompt [] {
    mut home = ""
    mut username = ""
    mut hostname = ""
    try {
        if $nu.os-info.name == "windows" {
            $home = $env.USERPROFILE
            $username = $env.USERNAME
            $hostname = $env.USERDOMAIN
        } else {
            $home = $env.HOME
            $username = $env.USER
            $hostname = (sys | hostname)
        }
    }

    let dir = ([
        ($env.PWD | str substring 0..($home | str length) | str replace --string $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let username = if (is-admin) {([$username ($"(ansi red_bold)\(Admin\)")] | str join)
        } else {$username}

    let path_color = (if (is-admin) { ansi red_bold } else { ansi blue_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_blue_bold })
    let user_color = (ansi blue_bold)
    let domain_color = (ansi green_bold)


    let path_segment = $"(ansi reset)╭ nu ($user_color)($username)($domain_color)@($hostname)(ansi reset):($path_color)($dir)(ansi reset)\n╰ "

    $path_segment | str replace --all --string (char path_sep) $"($separator_color)/($path_color)"
}

def create_right_prompt [] {
    let time_segment_color = (ansi magenta)

    let time_segment = ([
        (ansi reset)
        $time_segment_color
        (date now | date format '%m/%d/%Y %r')
    ] | str join | str replace --all "([/:])" $"(ansi magenta)${1}($time_segment_color)" |
        str replace --all "([AP]M)" $"(ansi magenta)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = {|| create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = {|| "> " }
let-env PROMPT_INDICATOR_VI_INSERT = {|| ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
let-env PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# Add Zoxide
zoxide init nushell | save -f ~/.zoxide.nu