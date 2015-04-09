#### Clone a repo into a directory (*dir* can be relative):
  git clone \<url\> \<dir\>
#### Remotes management:
  git remote -v  
  git remote rm \<name\>  
  git remote add \<name\> \<url\>  
  git remote rename \<name\>  
  git remote show \[name\]  
  git merge --squash \<name\> *# will stage a merge with all commits squashed*  
  git config --global credential.helper wincred *# set to cache auth credentials for about 15 mins*  
  git branch --set-upstream-to=\<remote-name\>/\<branch-name\> \<branch-name\> *# sets the remote tracking branch*  
  git push \<remote-name\> \<local-branch\>\[:remote-branch\]
  git status -u no *# check local rep status relative to remote