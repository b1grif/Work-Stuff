@echo off
if [%1]==[] goto :Usage
if not exist "%1\$RECYCLE.BIN" goto :NotFound

:main
  pushd %1\$RECYCLE.BIN
  echo. Removing contents of %CD%
  for /r %%a in (*) do (
    echo.   %%a
    takeown /f "%%a"
    del /f "%%a"
    )
  popd
  goto :eof

:NotFound
  echo.
  echo. Error: Problem accessing %1\$RECYCLE.BIN.
  echo.
  goto :Usage

:Usage
  echo.
  echo. -=[%~nx0]=- Empty recycle bin for a single drive. Example:
  echo.
  echo. %~n0 E:
  echo.
  goto :eof