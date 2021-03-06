$teacherRepo = "https://api.github.com/repos/andpop-mrsu/" 
$headers = @{}
$headers.Add("Authorization", "Basic andpop-mrsu PAT-here!!!")
$studentFolder = (Split-Path -Leaf -Path (Get-Location))

$response = Invoke-RestMethod -Uri "${teacherRepo}${studentFolder}/pulls" -Headers $headers

$studentRepo = $response[0].head.repo.clone_url
$task = $args[0]

git pull teacher master
git remote add student $studentRepo
git fetch student
git merge -m "Merge $task from student" student/$task


