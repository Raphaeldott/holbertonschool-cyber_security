#!/bin/bash
echo "$(echo -n "$1" | md5sum | cut -d " " -f 1)" > 2_hash.txt
