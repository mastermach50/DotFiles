# Nushell Environment Config File
#
# version = "0.88.2"

def get_git_branch [] {
    let git_out = do { git branch --show-current } | complete

    if ( $git_out | get exit_code ) != 0 {
        return ""
    } else { 
        return $"(ansi light_red)󰊢 ($git_out | get stdout | str trim )"
    }
}

def create_left_prompt [] {
    let home =  $nu.home-path
    let sys_static = sys
    let hostname = ($sys_static | get host | get hostname )
    mut username = ""
    mut platform = ""
    let os_name = ($sys_static | get host | get name )
    let git_branch = ""

    # Extra Features
    let git_branch = get_git_branch

    # Find username
    if $os_name == "Windows" {
        $username = $env.USERNAME
    } else {
        $username = $env.USER
    }

    # Set platform icon
    if ($os_name == "Windows" ) {
        $platform = ""
    } else if ($os_name | str contains "Debian") {
        $platform = ""
    } else if ($os_name == "NixOS") {
        $platform = ""
    } else {
        $platform = ""
    }

    # Detect WSL
    if ($nu.os-info.kernel_version | str downcase | str contains "wsl") {
        $platform = ([$platform " (wsl)"] | str join)
    }


    # Perform tilde substitution on dir
    # To determine if the prefix of the path matches the home dir, we split the current path into
    # segments, and compare those with the segments of the home dir. In cases where the current dir
    # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will
    # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
    # Inside the condition, either:
    # 1. The home prefix will be replaced
    # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    # Add (Admin) to username if user is root
    if (is-admin) {
            $username = ([$username ($"(ansi red_bold)\(Admin\)")] | str join)
    }

    # Set the colors
    let path_color = (if (is-admin) { ansi light_red_bold } else { ansi light_blue_bold })
    let separator_color = $path_color
    let username_color = (ansi blue_bold)
    let hostname_color = (ansi green_bold)
    let platform_color = (ansi light_yellow)

    # Create the prompt
    let prompt_str = $"(ansi reset)╭ ($env.SHELL) ($platform_color)($platform) ($username_color)($username)($hostname_color)@($hostname)(ansi reset):($path_color)($dir) ($git_branch)(ansi reset)\n╰ "

    # Not needed since $separator_color is same as $path_color
    #$path_segment | str replace --all (char path_sep) $"($separator_color)/($path_color)"
    $prompt_str
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X %p') # try to respect user's locale
    ] | str join # | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        # str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")
    )

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }
    
    # Execution time
    let duration = if (($env.CMD_DURATION_MS | into int) > 50) {
        ([
            (ansi reset)
            (ansi magenta)
            ($"($env.CMD_DURATION_MS)ms" | into duration)
        ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $duration, (char space), $time_segment] | str join)
}

#Set the SHELL environment variable
$env.SHELL = "nu"

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
$env.TRANSIENT_PROMPT_COMMAND = {|| $"(ansi light_blue_bold)nu(ansi reset)" }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# TEMP FIX
if $nu.os-info.name == "windows" {
    $env.Path = (do $env.ENV_CONVERSIONS.Path.from_string $env.path)
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# Add cargo to Path
# $env.Path = ($env.Path | split row (char esep) | prepend "~/.cargo/bin/")

# TEMP FIX
if $nu.os-info.name == "linux" {
    $env.PATH = ($env.PATH | split row (char esep) | prepend "~/.cargo/bin/")
}

# Zoxide
zoxide init nushell | save -f ~/.zoxide.nu

# Carapace
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu