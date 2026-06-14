#!/bin/bash
cava -p ~/.config/cava/config | sed -u 's/;//g;s/0/ /g;s/1/▁/g;s/2/▂/g;s/3/▃/g;s/4/▄/g;s/5/▅/g;s/6/▆/g;s/7/█/g' | while IFS= read -r line; do
    if [[ "$line" =~ ^[[:space:]]*$ ]]; then
        printf '{"text":"","class":"silent"}\n'
    else
        printf '{"text":"%s","class":"active"}\n' "$line"
    fi
done
