#!/bin/bash
echo "$(echo -n "$1" | sha1sum | cut -d " " -f 1)" > 0_hash.txt
