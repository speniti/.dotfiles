const php = { image: 'docker.io/speniti/devcontainers/php', version: '8.5' }
const node = { image: 'docker.io/library/node', version: 'lts-alpine' }

let rootless = [
    --volume /etc/passwd:/etc/passwd:ro
    --volume /etc/group:/etc/group:ro
    --user $"(id -u):(id -g)"
]

let common = ([ --rm -it -v ($env.PWD):/app -w /app ] | append $rootless)

def --wrapped php [...args] {
    docker run ...$common $'($php.image):($php.version)' php ...$args
}

def --wrapped composer [...args] {
    let composer_home = $'($env.HOME)/.composer'
    mkdir $composer_home | ignore

    let flags = ($common | append [
        --env COMPOSER_HOME
        --volume ($env.COMPOSER_HOME? | default $composer_home):/$COMPOSER_HOME
    ])

    docker run ...$flags $'($php.image):($php.version)' composer ...$args
}

def --wrapped node [...args] {
    docker run ...$common $'($node.image):($node.version)' node ...$args
}

let npm_home = $'($env.HOME)/.npm'

let npm_flags = ($common | append [
    -v $'($npm_home):/npm'
    -e NPM_CONFIG_PREFIX=/npm
])

def --wrapped npm [...args] {
    mkdir $npm_home | ignore

    docker run ...$npm_flags $'($node.image):($node.version)' npm ...$args
}

def --wrapped npx [...args] {
    mkdir $npm_home | ignore

    docker run ...$npm_flags $'($node.image):($node.version)' npx ...$args
}
