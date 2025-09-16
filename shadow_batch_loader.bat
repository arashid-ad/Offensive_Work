@echo off
setlocal enabledelayedexpansion

:: Check if Base64 content is provided
if "%~1"=="" (
    echo Usage: %~nx0 "base64_encoded_content"
    echo Example: %~nx0 "QGVjaG8gSGVsbG8gV29ybGQh"
    exit /b 1
)

:: Get the Base64 content from command line
set "B64_CONTENT=%~1"

:: Temporary files
set "TEMP_ENC=%TEMP%\temp_script.b64"
set "TEMP_BAT=%TEMP%\temp_script_%RANDOM%.bat"

:: Write Base64 to temporary file
echo !B64_CONTENT! > "!TEMP_ENC!"

:: Decode Base64 to batch file
certutil -decode "!TEMP_ENC!" "!TEMP_BAT!" >nul 2>&1

:: Check if decoding was successful
if not exist "!TEMP_BAT!" (
    echo Error: Failed to decode Base64 content
    goto cleanup
)

:: Execute the decoded batch file with any additional arguments
echo Executing decoded script...
echo.
shift /1
call "!TEMP_BAT!" %*

:cleanup
:: Cleanup temporary files
del "!TEMP_ENC!" >nul 2>&1
del "!TEMP_BAT!" >nul 2>&1

endlocal