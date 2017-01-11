# Git

## How to...

### Cancel conflicting merge on a branch (uncommited merge)
> `$ git merge --abort`

### Unmerge recently unpushed merged branch (if you haven't committed anything else ever since)
> `$ git reset --hard HEAD^`

## Uncommit last unpushed commit (it won't erase the changes)
> `git reset --soft HEAD^`

### To undo a merge that was already pushed
> `$ git revert -m 1 <commit_hash_of_merge_commit>`

### Undo almost everything

> https://github.com/blog/2019-how-to-undo-almost-anything-with-git

### Tips

> http://mislav.net/2010/07/git-tips/

### Ref

> http://gitref.org/index.html
