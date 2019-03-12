---
layout: default
title: Design
nav_order: 10
---

# Design
{: .no_toc }
The 'start beta' and 'release' commands are implemented using a combination of a repository server, 
a build server and Fastlane.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

### Repository Server  
The repository server can run any git server, such as GitHub, GitLab, etc. The git tag, in
     [semver](https://semver.org/) format, is used as the version name.
### Build Server  
The build server can be provided by Travis, Cirrus, an internal server running GitLab, Jenkins, etc.. The build server
    should provide a method to get the build number. The build number is used to ensure the release in
    both stores can be related back to the source code that was used to generate the app.
### Fastlane  
Fastlane builds the ios and android apps and uploads them to the respective stores.
This occurs on the build server.

### Fledge
Fledge is a command line utility used to control the entire CI/CD process. It plays the following roles:
1. Deliver the Fastlane files to the Flutter project.  
The Fastlane files are committed to the remote repo and called by the build server.
1. Deliver the build server file to the Flutter project.  
The build server file is used to set-up the environment for running the Fastlane files in a suitable macOS and Linux environment.
1. Control the beta releases.  
When the app is ready for a beta release (for example, after a new features is added or a bug is fixed), a Fledge command will trigger the build server to begin a beta release to both store consoles.
1. Control the releases to both stores.  
At the point when each beta is ready for release, a Fledge command will trigger the build server to begin a release to both stores.

---
