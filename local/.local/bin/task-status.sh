#!/bin/bash

task &> ${XDG_CONFIG_HOME}/task/status.txt
TASK_COUNT=$(task status:pending count)
TASK_STRING="${TASK_COUNT} Tasks"
if grep -q "Sync required" ${XDG_CONFIG_HOME}/task/status.txt
then
    TASK_STRING="${TASK_STRING} - #[fg=red,bg=default]Task sync required.#[fg=default,bg=default]"
fi
echo "${TASK_STRING}"
