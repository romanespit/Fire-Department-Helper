@echo off
set /P version= Choose version (1 - with in-game updates, 2 - without in-game updates): 
md FDHelper
md lib
if %version%==2 (curl -L https://raw.githubusercontent.com/romanespit/Fire-Department-Helper/refs/heads/main/FireDeptHelperNoAutoUpdate.lua > FireDeptHelperNoAutoUpdate.lua) else (curl -L https://raw.githubusercontent.com/romanespit/Fire-Department-Helper/refs/heads/main/FireDeptHelper.lua > FireDeptHelper.lua)
cd FDHelper
md files
cd files
curl -L https://raw.githubusercontent.com/romanespit/Fire-Department-Helper/refs/heads/main/FDHelper/files/logo-firedepthelper.png > logo-firedepthelper.png
curl -L https://raw.githubusercontent.com/romanespit/Fire-Department-Helper/refs/heads/main/FDHelper/files/font-icon.ttf > font-icon.ttf
cd ../..
cd lib
curl -L https://raw.githubusercontent.com/romanespit/Fire-Department-Helper/refs/heads/main/docs/lib/faIcons.lua > faIcons.lua
curl -L https://raw.githubusercontent.com/romanespit/Fire-Department-Helper/refs/heads/main/docs/lib/rkeysFD.lua > rkeysFD.lua
cls
echo Success installation!
pause