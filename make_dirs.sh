#!/bin/bash

BASE_DIR="/home/andrey/labs_303"
REPS_FILE="reps.txt"
# TEACHER_PROFILE="https://github.com/andpop-mrsu"
# Привязку к удаленному репозиторию делаем по SSH, а не по HTTPS
TEACHER_PROFILE="git@github.com-mrsu:andpop-mrsu"
TEACHER_EMAIL="andrvpopov@gmail.com"

for rep in $(cat $REPS_FILE) ; do
    student_dir="${BASE_DIR}/$rep"
    if ! [ -d $student_dir ] ; then
        echo "Make directory: for ${student_dir}"
        mkdir $student_dir
    fi
    cd $student_dir
    git init
    git config user.email $TEACHER_EMAIL
    git remote add teacher "${TEACHER_PROFILE}/${rep}.git"
    git fetch teacher
    git checkout --track teacher/master
done
