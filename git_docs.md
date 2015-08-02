#### Git commands and info:
----------------------------
#### Settings:
- set credentials (append _--global_ to set them globally):
```
git config user.name "name"
git config user.email "email@email.com"
```
- set line ending (accepts _true/false/input_; _input_ only pushes linux style endings):
```
git config --global core.autocrlf input
```
- add an alias (can also be manually added in the .gitconfig file):
```
git config --global alias.<alias-name> 'git-command'
```
#### Clone a repo into a directory (_dir_ can be relative):
```
git clone <url> <dir>
```
#### Remotes management:
```
git remote -v
git remote rm <name>
git remote add <name> <url>
git remote rename <name>
git remote show [name]
```
#### Maintenance:
```
# validate repo and check dangling objects. Use --lost-found for lost commits, --unreachable for unreachable
git fsck

# for commits refered by reflog but not attached to any branch (once they expire they get cleaned by git gc)
git fsck --no-reflogs

# show what something contains
git show <sha>

# Compact repo. Can use --aggressive. Use --prune=now to prune all loose objects and not wait for them to expire
git gc

# remote tracking branches
git remote update --prune
```
#### Other:
```
# will stage a merge with all commits squashed
git merge --squash <name>

# set to cache auth credentials for about 15 mins
git config --global credential.helper wincred

# print all the branches (can also be used to see the checked out branch):
git branch

# sets the remote tracking branch
git branch --set-upstream-to=<remote-name>/<branch-name> <branch-name>

# push to a specific remote and branch
git push <remote-name> <local-branch>[:remote-branch]

# check local rep status relative to remote
git status -u no

# add -x to delete ignored files too, use -n to dry-run
git clean -f -d

# resets to the last common commit
git reset <remote-name>/<branch-name>
```
#### Some personal conventions:
##### Aliases:
```
  co = checkout
  cob = checkout -b
  delb = branch -d
  tree = log --graph --decorate --pretty=oneline --abbrev-commit
  vtree = !gitk --all
  # from SeverB
  changes = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --date-order
  lola = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --date-order --all
```
##### Branching:
- _master_ - latest released version
- _develop_ - latest development version
- _dev-###_ - feature or development batch which will be added to the _develop_ branch after completion
- _exp-###_ - experimental branch
- _fix-###_ - bug fix branch
