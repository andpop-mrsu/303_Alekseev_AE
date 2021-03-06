#!/bin/bash

BASE_DIR="/home/andrey/labs_303"

pwd=$PWD
echo $pwd

task_number=$1

for student in $(cat "${pwd}/students-list_1.txt"); do
    echo "----------------------------------------------------------------------------------"
    echo $student
    student_dir="${BASE_DIR}/303_${student}"

    cd "${student_dir}"
    git fetch teacher master
    git merge teacher/master -m "Merging master from teacher repo"

    # cp "${pwd}/tasks/README.md" "${student_dir}/"
    # cp "${pwd}/tasks/task01.md" "${student_dir}/"
    # cp "${pwd}/tasks/Git_instruction.md" "${student_dir}/"
    cp "${pwd}/tasks/task04_1.md" "${student_dir}/task04.md"

    git add -A
    git commit -m "Change task04"
    git push teacher master
    cd "${pwd}"
done
