#### Git commands and info:
--------------------

#### Settings:
- set credentials (append --global to set them globally):  
**git config user.name _"name"_**  
**git config user.email _"email@email.com"_**  
- set line ending (accepts true/false/input; input only pushes linux style endings):  
**git config --global core.autocrlf _input_**  

#### Clone a repo into a directory (*dir* can be relative):
  **git clone _\<url\> \<dir\>_**  

#### Remotes management:  
**git remote -v**   
**git remote rm _\<name\>_**   
**git remote add _\<name\> \<url\>_**   
**git remote rename _\<name\>_**   
**git remote show _\[name\]_**   

#### Maintenance:
**git fsck** *# validate repo and check dangling objects. Use --lost-found for lost commits, --unreachable for unreachable*  
**git fsck --no-reflogs** *# for commits refered by reflog but not attached to any branch (once they expire they get cleaned by git gc)*  
**git show _\<sha\>_** *# show what something contains*  
**git gc** *# Compact repo. Can use --aggressive. Use --prune=now to prune all loose objects and not wait for them to expire*
**git remote update --prune** *# remote tracking branches*

#### Other:  
**git merge --squash _\<name\>_** *# will stage a merge with all commits squashed*  
**git config --global credential.helper wincred** *# set to cache auth credentials for about 15 mins*  
**git branch --set-upstream-to=_\<remote-name\>/\<branch-name\> \<branch-name\>_** *# sets the remote tracking branch*  
**git push _\<remote-name\> \<local-branch\>\[:remote-branch\]_**  
**git status -u no** *# check local rep status relative to remote*  
**git clean -f -d** *# add -x to delete ignored files too, use -n to dry-run*  
**git reset _\<remote-name\>/\<branch-name\>_** *# resets to the last common commit*  
