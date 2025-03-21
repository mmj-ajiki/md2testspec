#!/bin/bash

if [ -z "$1" ]; then
    echo "Specify a target MD file as the 1st argument"
    exit 0
fi

# Check the language option
target_lang="$MD2DOC_LANG"
if [ "$target_lang" = "" ]; then
    target_lang="jp"
elif [ "$target_lang" = "jp" ]; then
    echo "MD2DOC_LANG: $target_lang"
elif [ "$target_lang" = "en" ]; then
    echo "MD2DOC_LANG: $target_lang"
else
    echo "Set MD2DOC_LANG to en or jp"
    exit 0
fi

echo "TARGET MD FILE: $1"
echo "LANGUAGE: $target_lang"

# Header file
head_md_file=./test_util/$target_lang/Head.txt
# Footer file
foot_md_file=./test_util/$target_lang/Foot.txt

# Extract test items in a temporary file
perl ./test_util/detect_test_items.pl $1 $target_lang > "$1_temp"

# Create a test specificatoin file name (Replace .md with _testspec.md)
test_file="$1"
test_file=${test_file/.md/_testspec.md}

# Merge files
cat $head_md_file "$1_temp" $foot_md_file > $test_file
# Remove the temporary file
rm "$1_temp"

# UPDATE HISTORY
# 2025-01-23 - First release
