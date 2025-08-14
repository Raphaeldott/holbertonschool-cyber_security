#!/bin/bash
ssh-keygen -t rsa -b 4096 -f "$1" -C "$(whoami)@$(hostname)" -N ""
