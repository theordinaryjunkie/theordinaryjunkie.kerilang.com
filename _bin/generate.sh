#!/bin/bash

set -Eeuo pipefail

ROOT=$(dirname $(dirname "$(readlink -f "$0")"))
PRODUCT="$ROOT/content/product"

{
    read
    while IFS=, read -r NAME PRICE CONDITION AVAIL
    do
        DATE=$(date --utc --iso-8601=seconds)
        SLUG=`echo "$NAME" | iconv -t ascii//TRANSLIT | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z`
        FILE_PATH="$PRODUCT/$SLUG.md"
        CLEANED_AVAIL=$(echo "$AVAIL"|tr -d '\r')
        echo "$FILE_PATH"
        # cat << EOF
        cat > $FILE_PATH <<-EOF
---
title: "$NAME"
date: $DATE
price: "$PRICE"
availability: "$CLEANED_AVAIL"
condition: "$CONDITION"
images:
---

EOF
    done
} < "$1"
