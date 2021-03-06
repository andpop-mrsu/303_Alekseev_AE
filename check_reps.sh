
#!/bin/bash

repo=402_test
echo "Make repo for $repo"
curl -i -u andpop-mrsu:$token https://api.github.com/user/repos -d "{\"name\":\"$repo\",\"private\":false}"

curl https://api.github.com/repos/andpop-mrsu/402_Kudashkin_AF/pulls | jq  '.[0] | {name: .head.repo.name, number: .number, title: .title, time: .created_at}'
