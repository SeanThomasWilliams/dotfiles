#!/bin/bash

jq -r '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' < "${1:-/dev/stdin}"
