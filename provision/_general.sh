#!/bin/bash

HOME_DIRS=($(cat /etc/passwd | grep "/*sh$" | cut -d: -f6))
USERS=($(cat /etc/passwd | grep "/*sh$" | cut -d: -f1))

