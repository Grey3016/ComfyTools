@echo off
setlocal enabledelayedexpansion

@REM Get date in UK format (dd-MM-yyyy)
for /f "tokens=1-3 delims=/ " %%a in ('echo %date%') do set "UK_DATE=%%c-%%b"

@REM Remove leading space from time to avoid misalignment
set "cleanTime=%time: =0%"

@REM Extract hour and minute (without seconds or milliseconds)
for /f "tokens=1,2 delims=:." %%a in ("%cleanTime%") do (
    set "hour24=%%a"
    set "minute=%%b"
)

@REM Ensure two-digit hour and minute
if !hour24! lss 10 set hour24=0!hour24!
if !minute! lss 10 set minute=0!minute!

@REM Format the time in 24-hour format
set "UK_TIME=!hour24!-!minute!"

@REM Define output log file with date and time
set "LOGFILE=output_log_!UK_DATE!_!UK_TIME!.txt"



@REM Run commands and append their outputs to the log file
for %%i in ("%cd%") do set "folderPath=%%~fi"

@REM Write the current directory path to a text file

:: Get the current working directory
set "CWD=%CD%"

:: Check if the path contains the USERNAME
echo %CWD% | findstr /I "%USERNAME%" >nul
if errorlevel 1 (
    echo %CWD% >> directory_log.txt
    echo Run from: %CWD% >> %LOGFILE% 
) else (
    echo Directory contains username, not recorded >> %LOGFILE% 
)

::echo Run from:  >> %LOGFILE% 
::echo !folderPath! >> %LOGFILE%
echo. >> %LOGFILE%



@REM Save install type to Log - Check if Portable install
if not exist ".\python_embeded\" (
    goto :Desktop
)
echo ComfyUI - Portable install >> %LOGFILE%
goto :Next

:Desktop
@REM Save install type to Log - Check if Desktop install
if not exist ".\.venv" (
    goto :Clone
)
echo ComfyUI - Desktop install >> %LOGFILE%
goto :Next

:Clone
@REM Save install type to Log - Check if Cloned
if not exist ".\Comfyui\venv\" (
    echo You have placed the script in the wrong folder or other >> %LOGFILE%
	exit
)
echo ComfyUI - Cloned install >> %LOGFILE%
goto :Next
:Next
echo. >> %LOGFILE%






echo.
echo GPU Model and VRam: >> %LOGFILE% 
nvidia-smi --query-gpu=name,memory.total --format=csv,noheader >> %LOGFILE% 
echo. >> %LOGFILE%

echo iGPU Model: GPU 1 >> %LOGFILE% 
echo VRAM        Driver Version   iGPU >> %LOGFILE% 
wmic path win32_VideoController get Name, AdapterRAM, DriverVersion | findstr /I "Intel AMD" >> %LOGFILE%
echo. >> %LOGFILE%

echo Processor: >> %LOGFILE%
wmic cpu get Name | findstr /V "Name" >> %LOGFILE%
echo. >> %LOGFILE%

echo Memory Info: >> %LOGFILE%
systeminfo | findstr /C:"Total Physical Memory" /C:"Available Physical Memory" >> %LOGFILE%
echo. >> %LOGFILE%

echo Basic System Information: >> %LOGFILE%
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" >> %LOGFILE%
echo. >> %LOGFILE%

echo Pip Cache Info: >> %LOGFILE%
for /f "tokens=1,* delims=:" %%A in ('pip cache info') do (
    set "line=%%A"
    echo !line! | findstr /I "Package index page cache" >nul && set "cache_size=%%B"
)
(
    echo Package Index Cache Size: !cache_size!
) >> %LOGFILE%
echo. >> %LOGFILE%
   
echo System CUDA Version: >> %LOGFILE%
for /f "tokens=2 delims= " %%A in ('nvcc --version ^| findstr /C:"Build"') do (
    for /f "tokens=2 delims=_" %%B in ("%%A") do (
        for /f "tokens=1,2 delims=." %%C in ("%%B") do (
            echo Cuda %%C.%%D >> %LOGFILE%
        )
    )
)
echo. >> %LOGFILE%

echo CUDA Variables set to Variable Names: >> %LOGFILE%
for /f "tokens=1,* delims==" %%A in ('set') do (
    echo %%A | findstr /I "cuda" >nul && echo %%A=%%B  >> %LOGFILE% 2>&1
)
echo. >> %LOGFILE%

echo CUDA Environment Variables Paths - System and User: >> %LOGFILE%
@REM Check User PATH variables
@REM Get User PATH
for /f "tokens=2*" %%A in ('reg query "HKEY_CURRENT_USER\Environment" /v Path 2^>nul') do (
    set "userPath=%%B"
)
@REM Get System PATH
for /f "tokens=2*" %%A in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do (
    set "sysPath=%%B"
)
@REM Check User PATH variables
echo User CUDA Paths: >> %LOGFILE%
for %%A in ("%userPath:;=" "%") do (
    echo %%A | findstr /I "cuda" >nul && (
        set "var=%%~A"
        echo !var! >> %LOGFILE%
    )
)
echo. >> %LOGFILE%
@REM Check System PATH variables
echo System CUDA Paths: >> %LOGFILE%
for %%A in ("%sysPath:;=" "%") do (
    echo %%A | findstr /I "cuda" >nul && (
        set "var=%%~A"
        echo !var! >> %LOGFILE%
    )
)
echo. >> %LOGFILE%


@REM Check for Visual Studio installation
echo. >> %LOGFILE%
echo Microsoft Visual Studio Build Tools Environment Variables: >> %LOGFILE%
@REM Check for Visual Studio installation using vswhere
for /f "tokens=*" %%A in ('"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -prerelease -all -products * -requires Microsoft.VisualStudio.Workload.VCTools -property installationPath') do (
    set "VS_INSTALL_PATH=%%A"
)
@REM If VS_INSTALL_PATH is found, extract key environment variables
if defined VS_INSTALL_PATH (
    echo VSINSTALLDIR=!VS_INSTALL_PATH! >> %LOGFILE%
    echo VCToolsInstallDir=!VS_INSTALL_PATH!\VC\Tools\MSVC >> %LOGFILE%
    echo MSBuildSDKsPath=!VS_INSTALL_PATH!\MSBuild\Current\Bin >> %LOGFILE%
)
@REM Check system and user variables manually
for /f "tokens=1,* delims==" %%A in ('set') do (
    echo %%A | findstr /I "VS VC VCTools MSBuild VisualStudio WindowsSDK BuildTools" >nul && (
        echo %%A=%%B >> %LOGFILE%
    )
)
@REM Get the PATH environment variable
set "path_dirs=%PATH%"
@REM Initialize a flag to indicate if cl.exe is found
set "found_cl=0"
@REM Iterate through each directory in the PATH
for %%D in ("%path_dirs:;=" "%") do (
    @REM Remove surrounding quotes from %%D (if present)
    set "clean_path=%%~D"

    @REM Check if cl.exe exists in the current directory
    if exist "!clean_path!\cl.exe" (
        set "found_cl=1"
        echo MSVC Compiler cl.exe Path=!clean_path! >> %LOGFILE%
        goto :end_check
    )
)
@REM If cl.exe was not found, print a message
if %found_cl% equ 0 (
    echo cl.exe is NOT found in the PATH - recheck your Paths. >> %LOGFILE%
	echo MSVC should be found at C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.43.34808\bin\Hostx86\x64\ - recheck your Paths. >> %LOGFILE%
	echo Your install might be slightly different depending on versions etc - check the actual folder  >> %LOGFILE%
)
:end_check
echo. >> %LOGFILE%
echo. >> %LOGFILE%


echo System Python Version: >> %LOGFILE%
python --version >> %LOGFILE% 2>&1
echo. >> %LOGFILE%

echo Check System Python Install to Path: >> %LOGFILE%
@REM Searching for Python Executables in PATH:

for %%A in (python.exe py.exe) do (
    for %%B in (%%~$PATH:A) do (
        echo %%A found at: %%~nxB
        set "FOUND_%%A=1"
    )
)
if defined FOUND_python.exe (
    echo python.exe found in Paths >> %LOGFILE%
) else (
    echo python.exe NOT found in the system paths >> %LOGFILE%
)

if defined FOUND_py.exe (
    echo py.exe found in Paths >> %LOGFILE%
) else (
    echo py.exe NOT found in the system paths >> %LOGFILE%
)
echo. >> %LOGFILE%


@REM List Folders in Custom_Nodes
echo Installed in Custom_Nodes >> %LOGFILE%
echo ========================= >> %LOGFILE%
@REM Step 1: Check if the ComfyUI folder exists ie is this a Desktop install
if not exist ".\ComfyUI\" (
    goto :folder
)
set "target=.\ComfyUI\custom_nodes"  REM Change this to your desired folder path
for /d %%i in ("%target%\*") do (
    if /i not "%%~nxi"==".disabled" if /i not "%%~nxi"=="__pycache__" echo %%~nxi >> %LOGFILE% 2>&1
)
:folder
set "target=.\custom_nodes"  REM Change this to your desired folder path
for /d %%i in ("%target%\*") do (
    if /i not "%%~nxi"==".disabled" if /i not "%%~nxi"=="__pycache__" echo %%~nxi >> %LOGFILE% 2>&1
)


@REM Get Embeded, Venv or .Venv Python version
@REM Step 1: Check if the python_embeded folder exists
if not exist ".\python_embeded\" (
    goto :venv
)
echo. >> %LOGFILE%
echo Embedded Python Version: >> %LOGFILE%
.\python_embeded\python.exe --version >> %LOGFILE% 2>&1
echo. >> %LOGFILE%
echo Embedded PyTorch and Cuda Version: >> %LOGFILE%
.\python_embeded\python.exe -c "import torch; print(torch.__version__)" >> %LOGFILE% 2>&1
echo. >> %LOGFILE%
echo Embedded Packages Install Details >> %LOGFILE%
echo ================================= >> %LOGFILE%
cd "python_embeded\Lib\site-packages" && pip list >> "..\..\..\%LOGFILE%" 2>&1
exit


@REM Continue execution at :.venv
:venv
@REM Step 2: Check if the .venv folder exists in Desktop install
if not exist ".venv" (
    goto :venv2
)
echo. >> %LOGFILE%
call .venv\Scripts\activate.bat
echo .Venv Activated
echo .Venv Python Version: >> %LOGFILE%
.\.venv\Scripts\python.exe --version >> %LOGFILE% 2>&1
echo. >> %LOGFILE%
echo .Venv PyTorch and Cuda Version: >> %LOGFILE%
.\.venv\Scripts\python.exe -c "import torch; print(torch.__version__)" >> %LOGFILE% 2>&1
echo. >> %LOGFILE%
echo .Venv Packages Install Details >> %LOGFILE%
echo ============================== >> %LOGFILE%
cd .\.venv\Lib\site-packages 
pip list >> "..\..\..\%LOGFILE%"
Deactivate
exit

@REM Continue execution at :venv
:venv2
@REM Step 3: Must be using a Cloned install - no check installed to see if script has been run in the wrong folder
echo. >> %LOGFILE%
call ComfyUI\venv\Scripts\activate.bat
echo Venv Activated
echo Venv Python Version: >> %LOGFILE%
.\ComfyUI\venv\Scripts\python.exe --version >> %LOGFILE% 2>&1
echo. >> %LOGFILE%
echo Venv PyTorch and Cuda Version: >> %LOGFILE%
.\ComfyUI\venv\Scripts\python.exe -c "import torch; print(torch.__version__)" >> %LOGFILE% 2>&1
echo. >> %LOGFILE%
echo Venv Packages Install Details >> %LOGFILE%
echo ============================= >> %LOGFILE%
cd "ComfyUI\venv\Lib\site-packages" && pip list >> "..\..\..\..\%LOGFILE%"
Deactivate



@REM Show completion message
echo Log saved to %LOGFILE%
endlocal
pause