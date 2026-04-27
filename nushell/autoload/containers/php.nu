# PHP container wrappers
#
# @category 'containers'

const php_config = { image: 'docker.io/speniti/devcontainers/php', version: '8.5' }

# Get Docker flags for running as current user (rootless mode)
def rootless [] {
    [
        --volume /etc/passwd:/etc/passwd:ro
        --volume /etc/group:/etc/group:ro
        --user $"(id -u):(id -g)"
    ]
}

# Get common Docker flags for all container runs
def common [] {
    ([ --rm -it --network host -v ($env.PWD):/app -w /app ] | append (rootless))
}

# Generate or update the PHP wrapper script
#
# @param --force Force regeneration even if version hasn't changed
def wrap-php [--force] {
    let stub_path = $'($env.HOME)/Code/.dotfiles/nushell/autoload/containers/stubs/php-wrapper.bash'
    let current_version = $'($php_config.image):($php_config.version)'

    let bin_dir = [$env.HOME .local bin] | path join
    let bin_path = $bin_dir | path join 'php'
    let version_marker = $bin_dir | path join '.php-version'

    let version_changed = if ($version_marker | path exists) {
        ($version_marker | open) != $current_version
    } else { true }

    let should_create = $force or (not ($bin_path | path exists)) or $version_changed

    if $should_create {
        ^mkdir -p $bin_dir | ignore

        let script = open $stub_path
            | str replace --all '{{HOME}}' $"($env.HOME)"
            | str replace --all '{{IMAGE}}' $php_config.image
            | str replace --all '{{VERSION}}' $php_config.version

        $script | save -f $bin_path
        ^chmod +x $bin_path

        $current_version | save -f $version_marker
    }
}

# Run PHP in a Docker container
#
# @example 'Check PHP version'
# ```nu
# php -v
# ```
def --wrapped php [...args] {
    wrap-php
    ^docker run ...(common) $'($php_config.image):($php_config.version)' php ...$args
}

# Run Composer in a Docker container
#
# @example 'Check Composer version'
# ```nu
# composer -v
# ```
def --wrapped composer [...args] {
    wrap-php
    let composer_home = $'($env.HOME)/.composer'
    ^mkdir -p $composer_home | ignore

    let flags = (common | append [
        --env COMPOSER_HOME=/.composer
        --volume $'($composer_home):/.composer'
    ])

    ^docker run ...$flags $'($php_config.image):($php_config.version)' composer ...$args
}
