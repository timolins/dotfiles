function fish_prompt
    set -l normal (set_color normal)
    set -l dim (set_color brblack)
    set -l blue (set_color blue)
    set -l cyan (set_color cyan)
    set -l yellow (set_color yellow)

    set -l cwd $blue(basename $PWD)

    set -l git_info
    set -l branch (git symbolic-ref --quiet --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
    if test -n "$branch"
        set git_info $dim" on "$cyan$branch
        if not git diff-index --cached --quiet HEAD -- 2>/dev/null; or not git diff --no-ext-diff --quiet --exit-code 2>/dev/null
            set git_info $git_info$yellow"*"
        end
    end

    echo
    echo -n -s $cwd $git_info $normal
    echo
    echo -n -s "▲" $normal " "
end
