function peco-s3() {
    local -A opthash
    zparseopts -D -A opthash -- -recursive r

    local aws_path="${1%/}/"
    local aws_bucket=$(echo "${aws_path}" | awk -F / '{ print $1 }')
    local selected_line
    local recursive
    local recursive_opt
    local pecos3arg
    local selected_path
    local selected_bucket

    if [[ -n "${opthash[(i)--recursive]}" ]]; then
        recursive="on"
    fi

    if [[ -n "${opthash[(i)-r]}" ]]; then
        recursive="on"
    fi

    if [ "$recursive" = "on" ]; then
        recursive_opt="--recursive"
    else
        recursive_opt=""
    fi

    # List all of buckets and open the selected one
    if [ "${aws_path}" = "/" ]; then
        while true
        do
            selected_line=$(aws s3 ls s3://${aws_path} | peco --on-cancel error --prompt "s3://>")

            if [ $? -ne 0 ]; then
                return 1
            fi

            selected_bucket=$(echo "${selected_line}" | awk '{ print $3 }')

            if [ -n "${selected_bucket}" ]; then
                peco-s3 ${recursive_opt} ${selected_bucket}

                if [ $? -eq 0 ]; then
                    return
                fi
            fi
        done
    fi

    while true
    do
        selected_line=$(aws s3 ls s3://${aws_path} ${recursive_opt} | peco --on-cancel error --prompt "s3://${aws_path%/}>")

        if [ $? -gt 0 ]; then
            return 1
        fi

        selected_path=$(echo "${selected_line}" | awk '{ print $NF }')

        if [ -n "${selected_path}" ]; then
            if [ $selected_path = "0" ]; then
                continue
            fi

            # When the selected path is a directory, open it
            if [ ${selected_path: -1} = "/" ]; then
                if [ "$recursive" = "on" ]; then
                    pecos3arg="${aws_bucket}/${selected_path%/}"
                else
                    pecos3arg="${aws_path}${selected_path%/}"
                fi
                peco-s3 ${recursive_opt} ${pecos3arg}

                if [ $? -eq 0 ]; then
                    return
                else
                    continue
                fi
            else
                if [ "$recursive" = "on" ]; then
                    print -z "s3cat s3://${aws_bucket}/${selected_path}"
                else
                    print -z "s3cat s3://${aws_path}${selected_path}"
                fi
                return
            fi
        fi
    done
}
