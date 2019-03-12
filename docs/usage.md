---
layout: default
title: Usage
nav_order: 3
---

# Usage
{: .no_toc }
*After the app, Fastlane, the store consoles, the remote repo and the build server have all been configured, you are ready to go for automation! Please follow the configuration details, available via the menu, before using Fledge.*

{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Starting a beta
 
To start a beta for both android and ios:

1. Commit local dev  
Make sure you are in the dev directory and all files are committed and pushed to remote repo.
1. Then enter:
```
$ fledge beta
```
This will automatically increment the semver version name (at the patch level), generate a git tag, and push the git tag to the remote `dev`. This push will trigger the build server to build the app for ios and android and deploy each build to beta testers automatically on both stores.

When ready to start a new beta again, simply commit the code for the next beta to the remote `dev` and re-issue the `fledge beta` command.

## Release
When you are satisfied that the latest beta is complete it is time to make a release. 

At this point, your local dev branch has been synced to the remote dev branch and the build artifact is already in both stores. So making a release involves promoting the build in the beta track in both stores to a release.

1. Enter:
```
$ fledge release
```
This will confirm that the local `dev` is committed locally and as a precaution it confirms that no push is required from the local `dev` to the remote `dev`. Then it will merge the remote `dev` to the remote `master`. This will trigger the build server to promote each build used in beta testing to a release in both stores. The remote `master` now contains the most current code (the code used in the build that went thru beta testing).

A rebuild of the beta-tested build is not required because the build artifact is already present in both stores.

Note: currently Fledge auto-release is disabled in both stores. So the final step to release should be completed manually thru each store console.

## Semver
The semver version name can be incremented during a beta release using:

    fledge beta -r patch (the default)
    fledge beta -r minor
    fledge beta -r major
    
## Beta Help
Information about the beta command is available from the command line
```
$ fledge help beta
Triggers the build server to start a beta build and release to testers in both stores.

Usage: fledge beta [arguments]
-h, --help                       Print this usage information.
-r, --release=<release types>    Available release types:

          [major]                Major Release, eg, 1.0.0
          [minor]                Minor Release, eg, 0.1.0
          [patch] (default)      Patch Release, eg, 0.0.1

Run "fledge help" to see global options.
```