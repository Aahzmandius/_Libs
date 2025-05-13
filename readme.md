## Baldur's Gate 3 Libs
Note: Meant to be incorporated into SE mods via subtree (helpful explanation included below)
1. ReactiveX
2. FocusCore
3. AahzLib

***
## Subtrees explanation
https://gist.github.com/SKempin/b7857a6ff6bddb05717cc17a44091202

### Background
When you want to use a subtree, you add the subtree to an existing repository where the subtree is a reference to another repository url and branch/tag. This `add` command adds all the code and files into the main repository locally; it's not just a reference to a remote repo. 

When you stage and commit files for the main repo, it will add all of the remote files in the same operation. The subtree checkout will pull all the files in one pass, so there is no need to try and connect to another repo to get the portion of subtree files, because they were already included in the main repo.

### Adding a subtree
Let's say you already have a git repository with at least one commit. You can add another repository into this respository like this:

1. Specify you want to add a subtree
2. Specify the prefix local directory into which you want to pull the subtree
3. Specify the remote repository URL [*of the subtree being pulled in*]
4. Specify the remote branch [*of the subtree being pulled in*]
5. Specify you want to squash all the remote repository's [*the subtree's*] logs

`git subtree add --prefix {local directory being pulled into} {remote repo URL} {remote branch} --squash`

*For example:*

`git subtree add --prefix subtreeDirectory https://github.com/newfivefour/vimrc.git master --squash`
`git subtree add --prefix Mods/EasyCheat/ScriptExtender/Lua/_Libs https://github.com/Aahzmandius/_Libs.git main --squash`

This will clone `https://github.com/newfivefour/vimrc.git` into the directory `subtreeDirectory`.


***
### Pull in new subtree commits
If you want to pull in any new commits to the subtree from the remote, issue the same command as above, replacing `add` for `pull`:

`git subtree pull --prefix subtreeDirectory https://github.com/newfivefour/vimrc.git master --squash`
`git subtree pull --prefix Mods/EasyCheat/ScriptExtender/Lua/_Libs https://github.com/Aahzmandius/_Libs.git main --squash`


***
### Updating / Pushing to the subtree remote repository
If you make a change to anything in `subtreeDirectory` the commit will be stored in the **host repository** and its logs. That is the biggest change from submodules.

If you now want to update the subtree remote repository with that commit, you must run the same command, excluding `--squash` and replacing `pull` for `push`.

`git subtree push --prefix subtreeDirectory https://github.com/newfivefour/vimrc.git master`
`git subtree push --prefix Mods/EasyCheat/ScriptExtender/Lua/_Libs https://github.com/Aahzmandius/_Libs.git main`


***
### Subtree issues

* It isn't readily apparent that part of the main repo is built from a subtree
* You can't easily list the subtrees in your project
* You can't, at least easily, list the remote repositories of the subtrees
* The logs are slightly confusing when you update the host repository with subtree commits, then push the subtree to its host, and then pull the subtree.
