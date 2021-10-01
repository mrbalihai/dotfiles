#!/bin/bash

task &> ~/.task/status.txt
if grep -q "Sync required" ~/.task/status.txt
then
    echo '#[fg=red,bg=default]Task sync required.#[fg=default,bg=default]'
else
    echo ''
fi
