# Node.js container wrappers
#
# @category 'containers'

const node_config = { image: 'docker.io/library/node', version: 'lts-alpine' }

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

# Generate or update the Node wrapper script
#
# @param --force Force regeneration even if version hasn't changed
def wrap-node [--force] {
    let stub_path = $'($env.HOME)/Code/.dotfiles/nushell/autoload/containers/stubs/node-wrapper.bash'
    let current_version = $'($node_config.image):($node_config.version)'

    let bin_dir = [$env.HOME .local bin] | path join
    let bin_path = $bin_dir | path join 'node'
    let version_marker = $bin_dir | path join '.node-version'

    let version_changed = if ($version_marker | path exists) {
        ($version_marker | open) != $current_version
    } else { true }

    let should_create = $force or (not ($bin_path | path exists)) or $version_changed

    if $should_create {
        ^mkdir -p $bin_dir | ignore

        let script = open $stub_path
            | str replace --all '{{HOME}}' $"($env.HOME)"
            | str replace --all '{{IMAGE}}' $node_config.image
            | str replace --all '{{VERSION}}' $node_config.version

        $script | save -f $bin_path
        ^chmod +x $bin_path

        $current_version | save -f $version_marker
    }
}

# Get npm-specific flags (includes volume for global packages)
def npm-flags [] {
    let npm_home = $'($env.HOME)/.npm'
    let npm_lib = $'($npm_home)/lib'
    let npm_bin = $'($npm_home)/bin'

    ^mkdir -p ...[$npm_lib $npm_bin] | ignore

    (common | append [
        --volume $'($npm_lib):/npm/lib'
        --volume $'($npm_bin):/npm/bin'
        --env NPM_CONFIG_PREFIX=/npm
        --env HOME=/tmp
        --env PATH=/npm/bin:/usr/local/bin:/usr/bin:/bin
    ])
}

# Run Node in a Docker container
#
# @example 'Check Node version'
# ```nu
# node -v
# ```
def --wrapped node [...args] {
    wrap-node
    ^docker run ...(common) $'($node_config.image):($node_config.version)' node ...$args
}

# Run npm in a Docker container
#
# @example 'Check npm version'
# ```nu
# npm -v
# ```
# @example 'Install a package globally'
# ```nu
# npm install -g typescript
# ```
def --wrapped npm [...args] {
    wrap-node
    ^docker run ...(npm-flags) $'($node_config.image):($node_config.version)' npm ...$args
}

# Run npx in a Docker container
#
# @example 'Run a package without installing'
# ```nu
# npx prettier --check .
# ```
def --wrapped npx [...args] {
    wrap-node
    ^docker run ...(npm-flags) $'($node_config.image):($node_config.version)' npx ...$args
}
