#!/bin/bash

token=14114e26612df5133c39331f9cbdd45b7048c398

repo=402_test
echo "Make repo for $repo"
curl -i -u andpop-mrsu:$token https://api.github.com/user/repos -d "{\"name\":\"$repo\",\"private\":false}"
