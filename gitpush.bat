git add -A .
set /p declation="input commit:"
git commit -m "%declation%"
git push origin master
pause