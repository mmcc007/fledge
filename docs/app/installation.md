---
layout: default
title: Fledge Installation
parent: App Configuration
nav_order: 0
---

# Fledge Installation
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Dev branch
Create a dev branch
```
git checkout -b dev
```
## Select build server
Install the build server config file and Fastlane files
```bash
$ fledge config -b travis
```
To find out the supported build servers:
```
$ fledge config
```
Currently supported build servers:
```
GitLab-CI
Travis-CI
```
## Push to remote
Push your local repo to the remote repo.
```
git push --set-upstream origin dev
``` 

---