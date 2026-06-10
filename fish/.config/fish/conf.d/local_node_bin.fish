function __local_node_bin_update --on-variable PWD
    if set -q __local_node_bin_path
        set -l path_index (contains -i -- "$__local_node_bin_path" $PATH)
        if test -n "$path_index"
            set -e PATH[$path_index]
        end
        set -e __local_node_bin_path
    end

    set -l search_dir $PWD
    for level in (seq 0 2)
        set -l candidate "$search_dir/node_modules/.bin"
        if test -d "$candidate"
            set -g __local_node_bin_path "$candidate"
            set -gx PATH "$candidate" $PATH
            break
        end

        if test "$search_dir" = /
            break
        end
        set search_dir (path dirname "$search_dir")
    end
end

__local_node_bin_update
