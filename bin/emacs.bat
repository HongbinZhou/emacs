@echo off
@rem Put this file under <emacs installed dir>/bin
@rem Can't use double quote for %1 as "%1", because -c "" will cause a error
"%~dp0emacsclientw.exe" -na "%~dp0runemacs.exe" -c %1
