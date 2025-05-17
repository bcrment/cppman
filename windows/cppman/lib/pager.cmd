@echo off
REM !/bin/bash
REM
REM Adapted from original pager.sh
REM pager.cmd - Windows version
REM
REM Copyright (C) 2010 - 2016  Wei-Ning Huang (AZ) <aitjcize@gmail.com>
REM All Rights reserved.
REM Adapted by Bruno C. Rodrigues <bcrment@gmail.com>
REM 
REM This file is part of cppman.
REM
REM This program is free software; you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation; either version 3 of the License, or
REM (at your option) any later version.
REM
REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.
REM
REM You should have received a copy of the GNU General Public License
REM along with this program; if not, write to the Free Software Foundation,
REM Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
REM
REM Script arguments:
REM   $1: pager type
REM   $2: page path
REM   $3: column
REM   $4: vim config
REM   $5: page name
REM

setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM === Args ===
set "PAGER_TYPE=%1"
set "PAGE_PATH=%2"
set "COL=%3"
set "VIM_CONFIG=%4"
set "PAGE_NAME=%5"

REM === UTF-8 decodification in terminal (better output groff) ===
chcp 65001 >nul

REM === Verify if groff is install ===
where groff >nul 2>nul
if errorlevel 1 (
    echo erro: groff not found. Please, install groff in Windows.
    exit /b 1
)

REM === Define terminal output format (utf8 ou ascii) ===
set "OUTPUT_DEV=ascii"
for %%G in (%LC_ALL% %LANG%) do (
    echo %%G | findstr /I "utf8" >nul
    if not errorlevel 1 (
        set "OUTPUT_DEV=utf8"
        goto :after_encoding_check
    )
)
:after_encoding_check

REM === Function: render ===
REM Use groff to format the content of file man .gz
REM gzip -d -c = gunzip -c no Unix
REM Create temp file descompressed

set "TEMP_MAN=%TEMP%\cppman_page.man"
set "TEMP_PIPE=%TEMP%\cppman_clean.txt"

gzip -d -c "%PAGE_PATH%" | groff -t -c -m man -T%OUTPUT_DEV% -rLL=%COL%n -rLT=%COL%n > "%TEMP_MAN%" 2>nul

REM === verify pager exist for debug purpose ===
if /I "%PAGER_TYPE%"=="nvim" (
    where nvim >nul 2>nul
    if errorlevel 1 (
        echo
        echo "No %PAGER_TYPE% found"
        echo
        pause
        goto :fallback
    )
)

if /I "%PAGER_TYPE%"=="vim" (
    where vim >nul 2>nul
    if errorlevel 1 (
        echo.
        echo "No %PAGER_TYPE% found"
        echo.
        pause
        goto :fallback
    )
)

if /I "%PAGER_TYPE%"=="micro" (
    where vim >nul 2>nul
    if errorlevel 1 (
        echo.
        echo "No %PAGER_TYPE% found"
        echo.
        pause
        goto :fallback
    )
)

if /I "%PAGER_TYPE%"=="bat" (
    where bat >nul 2>nul
    if errorlevel 1 (
        echo.
        echo "No %PAGER_TYPE% found"
        echo.
        pause
        goto :fallback
    )
)

REM === Action for every pager ===

if /I "%PAGER_TYPE%"=="system" (
    if not defined PAGER (
        echo.
        echo "No %PAGER_TYPE% pager set"
        echo.
        pause
        goto :fallback
    )
    if /I "%PAGER%"=="vim" (
        vim --cmd "let g:is_cppman_active=1" -R -c "let g:page_name=\"%PAGE_NAME%\"" -S "%VIM_CONFIG%" "%TEMP_MAN%"
        goto :end
    )

    if /I "%PAGER%"=="nvim" (
        nvim --cmd "let g:is_cppman_active=1" -R -c "let g:page_name=\"%PAGE_NAME%\"" -S "%VIM_CONFIG%" "%TEMP_MAN%"
        goto :end
    )

    if "%PAGER%"=="bat" (
        bat "%TEMP_MAN%"
        cls
        goto :end
    )

    if /I "%PAGER%"=="less" (
        less -rf "%TEMP_MAN%"
        goto :end
    )

)

if /I "%PAGER_TYPE%"=="vim" (
    vim --cmd "let g:is_cppman_active=1" -R -c "let g:page_name=\"%PAGE_NAME%\"" -S "%VIM_CONFIG%" "%TEMP_MAN%"
    goto :end
)

if /I "%PAGER_TYPE%"=="nvim" (
    nvim --cmd "let g:is_cppman_active=1" -R -c "let g:page_name=\"%PAGE_NAME%\"" -S "%VIM_CONFIG%" "%TEMP_MAN%"
    goto :end
)

if "%PAGER_TYPE%"=="bat" (
    bat "%TEMP_MAN%"
    cls
    goto :end
)

if /I "%PAGER_TYPE%"=="less" (
    less -rf "%TEMP_MAN%"
    goto :end
)

if /I "%PAGER_TYPE%"=="pipe" (
    type "%TEMP_MAN%" | findstr /V /R /C:"\x1B\[[0-9;]*[mK]" > "%TEMP_PIPE%"
    type "%TEMP_PIPE%"
    del /q "%TEMP_MAN%" "%TEMP_PIPE%"
    goto :end
)


REM === Fallback ===
:fallback
more "%TEMP_MAN%"

:end

set PAGER_TYPE=
set PAGE_PATH=
set COL=
set VIM_CONFIG=
set PAGE_NAME=
del "%TEMP_MAN%"
if exist "%TEMP_PIPE%" (
    del "%TEMP_PIPE%")
set TEMP_MAN=
set TEMP_PIPE=

exit /b 1
