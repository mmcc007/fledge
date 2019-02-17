---
layout: default
title: Design
nav_order: 10
---

# Design
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Intro
The 'start beta' and 'release' commands are implemented using a combination of a repository server, 
a build server and Fastlane. 

### Repository Server  
The repository server can run any git server, such as GitHub, GitLab, etc. The git tag, in
     [semver](https://semver.org/) format, is used as the version name.
### Build Server  
The build server can be provided by Travis, Cirrus, an internal server running GitLab, Jenkins, etc.. The build server
    should provide a method to get the build number. The build number is used to ensure the release in
    both stores can be related back to the source code that was used to generate the app.
### Fastlane  
Fastlane plays two roles:
1. Building  
Fastlane builds the ios and android apps and upload them to the respective stores.
This occurs on the build server.
1.  Command support  
Fastlane supports the 'start beta' and 'release' commands.
This occurs on the local machine and triggers the corresponding build processes on the build server.

---
