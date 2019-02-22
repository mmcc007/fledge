---
layout: default
title: Goals
nav_order: 9
---

# Goals
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Intro


CICD is 'Continous Interation and Continous Delivery'. It is the idea of allowing developers
to focus on developing and reducing time spent on repetitive tasks, such as testing and 
delivery, using automation. For more details see ([CICD](https://en.wikipedia.org/wiki/CI/CD)).

This particular implementation of CICD is a slightly opinionated approach to CICD. It makes some simplifying assumptions
that seems to work well with Flutter. Of course, these assumptions do not prohibit evolving other CICD workflows after starting with Fledge.

## CI/CD Workflows
The idea behind Fledge is to support a simple, fully automated, workflow to get consistent and reliable releases to both stores for Flutter apps    .

Fledge supports the following simple CICD workflows:
### Beta testing workflow  
All development occurs in the `dev` branch and when
ready for beta, do a beta release to your beta tester
in both `Google Play Console` and `App Store Connect`.

Each time a new beta is ready, a 'start beta' command is issued and a new beta is started
and automatically released to testers.
### Release workflow  
When beta testing is complete, a 'release' command is issued and the `dev` branch is automatically
merged with the `master` branch and the release is uploaded to the `Apple Store` and the 
Google `Play Store`.

## Features
Fledge provides the following features:
### Build artifact consistency
The build artifact used to pass beta testing is the same build that is shipped to the stores. No rebuild
required.
### Build tracking
Using the version name (or the build number), the build can be traced back to the source used in the build.
    
The version name is the git tag, which tags the code used in the build. Alternatively the 
    build server records the commit ID used in the build next to the build number.
### User support
The app name, version name, and build number can be displayed in an 'About' section of the shipped
app for support and bug fixing. These values will be the same on both android and ios.

This allows tracing-back from any version of your app on any device, to the related build and source code. This can be used to resolve feature and bug issues.
### Fast and frequent releases
As an additional bonus, a beta can be started and the apps released to both stores in as long
as it takes the build server to run. This can be as fast as 15 minutes (not including Apple's 
review time).

This enables fast bug fixes.

### Flexible development environments
A by-product of the Fledge workflows is that development macs are not
required (except perhaps for setting-up match and for [screenshots](https://pub.dartlang.org/packages/screenshots)). Development can be done 
on Windows or Linux machines. The build server will take care of the ios-specific details of
building the ios app, starting the ios beta and release to the Apple Store.

---
