---
layout: default
title: Repo Configuration
nav_order: 7
---

# Repo Configuration
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Repo server setup

Assuming you have an empty remote repo:
### Commit  
Commit files on your local repo
### Create dev branch  
Create a `dev` branch on your local repo

        git checkout -b dev

### Push to remote  
Push your local repo to the remote repo.

        git push --set-upstream origin dev

### _Recommended_: Protect master branch  
On the repo server, it is recommended to set the `master` branch to protected and `dev` as the default branch. This is to prevent accidental manual pushes to the `master` branch.

    After this point
the remote `master` should be protected and should never be pushed-to manually. There should never
be a reason to even checkout the local `master` branch locally. 
For example, see https://help.github.com/articles/setting-the-default-branch and https://help.github.com/articles/configuring-protected-branches.

    All CICD commands should only then be issued from
the local `dev` branch (`fledge` will guarantee this).

---
