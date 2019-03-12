---
layout: default
title: Home
nav_order: 1
description: "Fledge - CI/CD for flutter. Automatically build, test (including integration tests), sign and release your Flutter app to both Apple and Google stores. Supports tracing-back from any version of app to your source code."
permalink: /
---

# Auto app delivery to both stores.
{: .fs-9 }

Give your Flutter app a jumpstart with a responsive CI/CD tool that is easily customizable.
{: .fs-6 .fw-300 }

Automatically build, test, sign and release your Flutter app to both Apple and Google stores.

Supports public and private build servers in both the cloud (Travis, Cirrus, etc...) and in-house (Jenkins, GitLab, etc...).

There are many steps involved each time an app, or an app upgrade, is delivered to both stores. Fledge exists to document and automate these steps.

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 } [View it on GitHub](https://github.com/mmcc007/fledge){: .btn .fs-5 .mb-4 .mb-md-0 }

---

## Getting started

### Quick start: Use with GitHub and Travis

Install Fledge to your local machine
```
$ pub global activate fledge
```

### Travis: Add secrets

Secret variables  
<small>Set your secret variables in:</small>  
```
https://travis-ci.org/<your name>/<your repo>/settings
```
![secret variables](./assets/images/travis_secret_env.png)  
<small>These variables are used for signing and uploading to both stores.</small>

### Local repo: Add app to Fledge

1. Create a dev branch
```
git checkout -b dev
```
1. Install the Travis config file and Fastlane files
```bash
$ fledge config -b travis
```
1. Push your local repo to the remote repo.
```
git push --set-upstream origin dev
``` 

### Local repo: Start a beta

Run pipeline on Travis
```
$ fledge beta
```
<small>This will build your app, upload to both store consoles and release to beta testers.</small>

### Local repo: Release

Release to users
```
$ fledge release
```
<small>This will release the app to users.</small>

### Fledge Usage

- [See Usage options]({{ site.baseurl }}{% link docs/usage.md %})

---

## About the project

Fledge is &copy; 2019 by [Maurice McCabe](http://mauricemccabe.com) and Contributors.

### License

Fledge is distributed by an [MIT license](https://github.com/mmcc007/fledge/tree/master/LICENSE.txt).

### Contributing

When contributing to this repository, please feel free to discuss via issue or pull request.

Read more about becoming a contributor in [our GitHub repo](https://github.com/mmcc007/fledge#contributing).

### Code of Conduct

Fledge is committed to fostering a welcoming community.

