#!/bin/bash

token=933f601265a6d003ca17bb6762eefe0d896ecdf2
rm ./reps.txt
for student in $(cat students-list.txt); do
   echo "303_$student" >> reps.txt
done

for repo in $(cat reps.txt) ; do
    echo "Make repo for $repo"

    curl -i -u andpop-mrsu:$token https://api.github.com/user/repos -d "{\"name\":\"$repo\",\"private\":false}"
done

# readarray repos < reps.txt
# echo ${repos[@]}
