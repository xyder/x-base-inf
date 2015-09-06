:: snippet that creates an archive for each subfolder of the current folder with the files contained in each
:: it assumes the 7za.exe is in the current directory or in the PATH variable
for /d %%i in (*) do 7za a "%%i.zip" ".\\%%i\\*"
:: to run  in console use:
:: for /d %i in (*) do 7za a "%i.zip" ".\\%i\\*"