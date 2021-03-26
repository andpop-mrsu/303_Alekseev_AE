#!/bin/bash
script=$(dirname $0)
pwsh "$script/check_task.ps1" -- $1
