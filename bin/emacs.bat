@echo off
@rem Put this file under <emacs installed dir>/bin
@rem Can't use double quote for %1 as "%1", because -c "" will cause a error

@rem "%~dp0emacsclientw.exe" -na "%~dp0runemacs.exe" -c %1

@rem get the binaries from $PATH
"emacsclientw.exe" -na "runemacs.exe" -c %1
