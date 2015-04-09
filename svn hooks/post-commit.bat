:: - for automatic backup place the post-commit script in the hooks folder
::   of the repository and make sure your backup Working Copy is created in the ../../backups/<repo-name> directory
::   relative to the hook directory
:: - also the working copy points to the trunk not the whole repository, otherwise you pull the tags too
:: example:
::   hook file: dir_name/repo_name/hooks/post-commit.bat
::   then backup working copy is: dir_name/backups/repo_name

:: Version:		1.0.0

pushd "%~dp0\..\"
for %%a in (.) do set repname=%%~na
pushd "..\backups\"
svn update %repname%