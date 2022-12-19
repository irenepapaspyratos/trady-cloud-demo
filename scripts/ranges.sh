#!/bin/bash

create_ranges() {
    ARRAY='eurusd:2003050400 eurgbp:2003080300'

    TODAY_DATE=`date +%Y%m%d%H`
    TODAY_STAMP=$(date -j -f "%Y%m%d%H" "${TODAY_DATE}" "+%s")

    for symbol in $ARRAY
        do
            key="${symbol%%:*}"
            value="${symbol##*:}"
            symbol_stamp=$(date -j -f "%Y%m%d%H" "${value}" "+%s")
            hours=$((($TODAY_STAMP - $symbol_stamp)/(60*60)))
            RANGE="$RANGE,\"$key\":$hours"
        done

    echo "$RANGE" | sed -r 's/^,//'
}
