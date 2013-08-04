@ECHO OFF
7z a -tzip %~dp0\client.love %~dp0\* -x!love.exe -x!OpenAL32.dll -x!SDL.dll -x!DevIL.dll
copy /b %~dp0\dist\love.exe+%~dp0\client.love %~dp0\client.exe