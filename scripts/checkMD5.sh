#!/bin/bash

files_with_errors_count = 0

while IFS=':' read -r expected_mdsum url
do
    md5_result="$(curl -L -m 5 --silent $url | md5sum | awk '{print $1}')"
    echo "✓ ${url}"
    if [ "$md5_result" != "$expected_mdsum" ]; then
        files_with_errors_count=$[$files_with_errors_count +1]
        echo "✘ ${url} (Excpected: '${expected_mdsum}', Actual: '${md5_result}')"
    fi
done

if (( $files_with_errors_count > 0 )); then
    echo "${files_with_errors_count} plugins did not have the correct md5 sum"
    exit 1
fi
