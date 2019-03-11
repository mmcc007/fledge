fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### start_beta
```
fastlane start_beta
```
Start a new beta by creating a tag for next release.

'bump' options are: major, minor, patch (default).

This will trigger the CICD to deliver the beta to testers.
### release
```
fastlane release
```
Complete current beta and release app by merging from dev to master.

This will trigger the CICD to deliver the latest app build to the Apple Store and Play Store.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
