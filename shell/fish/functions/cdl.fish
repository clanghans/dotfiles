function cdl
    echo "$history[1]" | read --array --tokenize result

    # Expand the tilde (~) to the full home directory path
    set -l last_arg (string replace "~" $HOME $result[-1])
    cd (dirname (realpath $last_arg))
end
