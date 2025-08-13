#!/bin/bash
file_hash=$(sha256sum "$1" | cut -d' ' -f1)
[ "$file_hash" = "$2" ] && echo "$1: OK" || echo "$1: FAILED"
