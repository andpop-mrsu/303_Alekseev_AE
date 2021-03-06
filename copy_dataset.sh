#!/bin/bash

BASE_DIR="/home/andrey/labs_303"

pwd=$PWD
echo $pwd

task_number=$1

for student in $(cat "${pwd}/students-list.txt"); do
    echo "----------------------------------------------------------------------------------"
    echo $student
    student_dir="${BASE_DIR}/303_${student}"

    cd "${student_dir}"
    # git fetch teacher
    # git merge -m "Merging from teacher repo"

    # cp "${pwd}/tasks/README.md" "${student_dir}/"
    # cp -R "${pwd}/tasks/dataset" "${student_dir}/"

        # if [ -f "${pwd}/tasks/specification_0${task_number}_0${option}.md" ]; then
        #     cp "${pwd}/tasks/specification_0${task_number}_0${option}.md" "${student_dir}/"
        # fi


        git add -A
        git commit -m "Change dataset"
        git push teacher master
        cd "${pwd}"
    done
