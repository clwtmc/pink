@echo off
setlocal

@echo off

where cl > nul 2> nul
if %ERRORLEVEL% equ 0 (
  exit /b
)

for /f "usebackq tokens=*" %%i in (`%~dp0\bin\vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set InstallDir=%%i
)

if exist "%InstallDir%\Common7\Tools\vsdevcmd.bat" (
  pushd .
  call "%InstallDir%\Common7\Tools\vsdevcmd.bat" %*
  popd
)

set PINK_HOME=%~dp0\dist
set PINK_OS=windows
  
dist\bin\pink.exe -nosourcemap -o src\c\out_pink.c src/pink

md dist\bin

cl /MP /FS /Ox /W0 /nologo src\c\pink.c /Fe:dist\bin\pink.exe /EHsc /link /SUBSYSTEM:CONSOLE /NODEFAULTLIB:msvcrt.lib /NODEFAULTLIB:LIBCMT  kernel32.lib vcruntime.lib msvcrt.lib 

endlocal
