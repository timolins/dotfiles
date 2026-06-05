function where --description 'Show all locations of a command (like zsh where)'
    if test (count $argv) -eq 0
        echo "where: missing argument" >&2
        return 1
    end
    for cmd in $argv
        type -a $cmd
    end
end
