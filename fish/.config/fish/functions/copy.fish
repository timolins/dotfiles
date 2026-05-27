function copy --description 'Copy the current directory or a path realpath'
    set -l copied_path

    if test (count $argv) -eq 0
        set copied_path (pwd)
    else if test (count $argv) -eq 1
        if not set copied_path (realpath -- $argv[1])
            return 1
        end
    else
        echo "copy: expected zero or one path" >&2
        return 2
    end

    printf "%s\n" $copied_path | pbcopy
    printf "Copied: %s\n" $copied_path
end
