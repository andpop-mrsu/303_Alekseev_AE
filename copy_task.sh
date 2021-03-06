#!/bin/bash

BASE_DIR="/home/andrey/labs_303"

pwd=$PWD
echo $pwd
if ! [ -n "$1" ]; then 
    echo "Не указан номер задания"
    exit 1
fi

task_number=$1

for option in `seq 1 5`; do
    echo "Вариант $option"
    for student in $(cat "${pwd}/option_${option}.txt"); do
        echo "----------------------------------------------------------------------------------"
        echo $student
        student_dir="${BASE_DIR}/402_${student}"

        cd "${student_dir}"
        git fetch teacher
        git merge -m "Merging from teacher repo"

        cp "${pwd}/tasks/README.md" "${student_dir}/"
        cp "${pwd}/tasks/task0${task_number}.md" "${student_dir}/"

        # if [ -f "${pwd}/tasks/specification_0${task_number}_0${option}.md" ]; then
        #     cp "${pwd}/tasks/specification_0${task_number}_0${option}.md" "${student_dir}/"
        # fi


        git add -A
        git commit -m "Change task ${task_number}"
        git push teacher master
        cd "${pwd}"
    done
done
