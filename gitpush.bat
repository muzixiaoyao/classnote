@echo off
echo "path:%cd%"
git add -A .
echo 
set /p declation="input commit:"
git commit -m "%declation%"
echo git push origin master
pause