---
layout: default
title: Fledge
parent: App Configuration
nav_order: 0
---

# Fledge
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Installation
If Fledge is not already installed
```
pub global activate fledge
```

## Dev branch
Create a dev branch
```
git checkout -b dev
```
## Select build server
Install the build server config file and Fastlane files
```bash
fledge config -b travis
```
To find out the supported build servers:
```
$ fledge help config
  Installs the build server config files.
  
  Usage: fledge config [arguments]
  -h, --help                          Print this usage information.
  -b, --buildserver=<build server>    Available build servers:
  
            [gitlab]                  GitLab-CI.
            [travis]                  Travis-CI.
  
  Run "fledge help" to see global options.
```
Currently supported build servers:
```
GitLab-CI (in-house version)
Travis-CI
```
## Push to remote
Push your local repo to the remote repo.
```
git push --set-upstream origin dev
``` 

---