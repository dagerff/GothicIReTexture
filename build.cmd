@echo off
set pathtoini=build.ini
set copyright=COPYRIGHT
set buildfiles=BuildFiles
set versiontexturepack=VERSION
set pathrootexture=GothicIReTexture
set gothicvdfscfg=%PATHROOTEXTURE%.vm
set pathtexturecompiled=%PATHROOTEXTURE%\_WORK\DATA\TEXTURES\_COMPILED
set SEPARATOR=%%%%N
:::     ^
:::    / \
:::   /   \
:::  |     |
:::  |BUILD|
:::  |     |
:::  |     |
:::  |     |
::: '       `
::: |TEXTURE|
::: | PACK  |
::: |_______|
:::  '-`'-`   .
:::  / . \'\ . .'
::: ''( .'\.' ' .;'
:::'.;.;' ;'.;' ..;;'
:::
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
for /f "delims== tokens=1,2" %%G in (%PATHTOINI%) do set %%G=%%H
for /f "delims== tokens=1,2" %%G in (%VERSIONTEXTUREPACK%) do set %%G=%%H
setlocal enabledelayedexpansion
set readcopyright=
for /f "delims=" %%i in ('type %COPYRIGHT%') do set readcopyright=!readcopyright! %%i
set readcopyright=%READCOPYRIGHT:~1%
if %DX11% EQU 1 (
echo Copying files for DirectX11
copy /Y "%BUILDFILES%\Dx11\*" "%PATHTEXTURECOMPILED%\" >nul
) else (
echo Deleting files for DirectX11. Use legacy DirectX
for /L %%d in (1 1 6) do (
del %PATHTEXTURECOMPILED%\MODERUNE0%%d-C.TEX 2>nul
)
)
if %LANG% EQU r (
echo Copying files with russian fonts
copy /Y "%BUILDFILES%\Fonts\Cyrillic\*" "%PATHTEXTURECOMPILED%\" >nul
) else (
echo Copying files with latin fonts
copy /Y "%BUILDFILES%\Fonts\Latin\*" "%PATHTEXTURECOMPILED%\" >nul
)
if %MAINLOADINGSCREEN% EQU 1 (
echo Copying files from the main loading screen with erotica
copy /Y "%BUILDFILES%\MainLoadingScreen\Erotic\*" "%PATHTEXTURECOMPILED%\" >nul
) else (
echo Copying files from the main loading screen with don't erotica
copy /Y "%BUILDFILES%\MainLoadingScreen\NoErotic\*" "%PATHTEXTURECOMPILED%\" >nul
)
if %PAINTINGS% EQU 1 (
echo Copying files from the erotic paintings
copy /Y "%BUILDFILES%\Paintings\Erotic\*" "%PATHTEXTURECOMPILED%\" >nul
) else (
echo Copying files from the don't erotic paintings
copy /Y "%BUILDFILES%\Paintings\NoErotic\*" "%PATHTEXTURECOMPILED%\" >nul
)
(echo [BEGINVDF]) > %GOTHICVDFSCFG%
(echo Comment="Version:%VERSION%%SEPARATOR%%READCOPYRIGHT%") >> %GOTHICVDFSCFG%
(echo BaseDir=%CD%\%PATHROOTEXTURE%) >> %GOTHICVDFSCFG%
(echo VDFName=%INSTALLPACKPATH%\%NAMEPACK%%VERSION%.vdf) >> %GOTHICVDFSCFG%
(echo TimeStamp=%TIMESTAMP%) >> %GOTHICVDFSCFG%
(echo [FILES]) >> %GOTHICVDFSCFG%
(echo *.* -r) >> %GOTHICVDFSCFG%
(echo [EXCLUDE]) >> %GOTHICVDFSCFG%
(echo [INCLUDE]) >> %GOTHICVDFSCFG%
(echo *.* -r) >> %GOTHICVDFSCFG%
(echo [ENDVDF]) >> %GOTHICVDFSCFG%
echo Building texture pack
GothicVdfs.exe /B "%CD%\%GOTHICVDFSCFG%"
echo Done^^^!
endlocal
