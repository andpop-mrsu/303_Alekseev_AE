$studentDir = "/home/andrey/labs_303/"
$teacherRepo = "https://api.github.com/repos/andpop-mrsu/" 
$headers = @{}
$headers.Add("Authorization", "Basic andpop-mrsu PAT-here!!!")

Get-ChildItem $studentDir -Attributes Directory | 
    ForEach-Object { 
        Out-Host -InputObject $_.Name
        $response = Invoke-RestMethod -Uri "${teacherRepo}$($_.Name)/pulls" -Headers $headers
        $obj = ($response | 
            Select-Object -Property @{label='repo'; expression={$_.head.repo.name}}, @{label='student_repo'; expression={$_.head.repo.clone_url}}, number, title, created_at)
        $obj | Format-List *
    }
