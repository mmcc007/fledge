[![pub package](https://img.shields.io/pub/v/fledge.svg)](https://pub.dartlang.org/packages/fledge)

<img src="https://upload.wikimedia.org/wikipedia/commons/1/15/Passarinho-azul-02.png" width="30%" title="Fledge" alt="Fledge">

See [article](https://medium.com/@nocnoc/cicd-for-flutter-fdc07fe52abd) for introduction to `fledge`.

For demo of `fledge` see [todo](https://github.com/mmcc007/todo) which shows 
`fledge` in use to deliver an app to both the Apple and Google stores. The app is live in both stores.

[![GitErDone](https://play.google.com/intl/en_us/badges/images/badge_new.png)](https://play.google.com/store/apps/details?id=com.orbsoft.todo)
[![GitErDone](https://linkmaker.itunes.apple.com/en-us/badge-lrg.svg?releaseDate=2019-02-15&kind=iossoftware)](https://itunes.apple.com/us/app/giterdone/id1450240301)

# CICD for Flutter

CICD is 'Continous Interation and Continous Delivery'. It is the idea of allowing developers
to focus on developing and reducing time spent on repetitive tasks, such as testing and 
delivery, using automation. For more details see ([CICD](https://en.wikipedia.org/wiki/CI/CD)).

This particular implementation of CICD is a slightly opinionated approach to CICD. It makes some simplifying assumptions
that seems to work well with Flutter. Of course, these assumptions do not prohibit evolving other CICD workflows after starting with `fledge`.

The idea behind `fledge` is to support a simple, fully automated, workflow to get consistent and reliable releases to both store.
:
1. Simple beta testing workflow  
All development occurs in the `dev` branch and when
ready for beta, do a beta release to your beta tester
in both `Google Play Console` and `App Store Connect`.

    Each time a new beta is ready, a 'start beta' command is issued and a new beta is started
and automatically released to testers.
1. Simple release workflow  
When beta testing is complete, a 'release' command is issued and the `dev` branch is automatically
merged with the `master` branch and the release is uploaded to the `Apple Store` and the 
Google `Play Store`.

`fledge` provides the following features:
1. Build artifact consistency  
The build used to pass beta testing is the same build that is shipped to the stores. No rebuild
required.
1. Consistent build tracking  
    Using the version name (or the build number), the build can be traced back to the source used in the build.
    
    The version name is the git tag, which tags the code used in the build. Alternatively the 
    build server records the commit ID used in the build next to the build number.
1. User support  
    The app name, version name, and build number can be displayed in an About section of the shipped
app for support and bug fixing. These values will be the same on both android and ios.

     This allows tracing-back from any version of your app on any device, to the related build and source code. This can be used to resolve feature and bug issues.
1. Fast and frequent releases  
As an additional bonus, a beta can be started and the apps released to both stores in as long
as it takes the build server to run. This can be as fast as 15 minutes (not including Apple's 
review time).

    This enables fast bug fixes.

1. Flexible development environments  
A by-product of the `fledge` workflows is that development macs are not
required (except perhaps for setting-up match and for [screenshots](https://pub.dartlang.org/packages/screenshots)). Development can be done 
on Windows or Linux machines. The build server will take care of the ios-specific details of
building the ios app, starting the ios beta and release to the `Apple Store`.
 
Table of Contents
=================

   * [CICD for Flutter](#cicd-for-flutter)
   * [Table of Contents](#table-of-contents)
   * [Implementation](#implementation)
   * [Setup](#setup)
      * [Application setup](#application-setup)
      * [Install fledge](#install-fledge)
      * [Plug app into fledge](#plug-app-into-fledge)
      * [Fastlane setup](#fastlane-setup)
      * [Google Play Console setup](#google-play-console-setup)
         * [Create new app in store](#create-new-app-in-store)
         * [Sign android app](#sign-android-app)
         * [Upload first apk](#upload-first-apk)
      * [Apple App Store Connect setup](#apple-app-store-connect-setup)
         * [Sign ios app](#sign-ios-app)
         * [Create required images](#create-required-images)
      * [Repo server setup](#repo-server-setup)
      * [Build server setup](#build-server-setup)
   * [Usage](#usage)
      * [Starting a beta for both android and ios](#starting-a-beta-for-both-android-and-ios)
      * [Release to both stores](#release-to-both-stores)
   * [The CI part of CICD](#the-ci-part-of-cicd)
   * [Issues and Pull Requests](#issues-and-pull-requests)
   
# Implementation

The 'start beta' and 'release' commands mentioned above are implemented using a combination of a repository server, 
a build server and fastlane. 

1. Repository Server  
The repository server can run any git server, such as GitHub, GitLab, etc. The git tag, in
     [semver](https://semver.org/) format, is used as the version name.
1. Build Server  
The build server can be provided by Travis, Cirrus, an internal server running GitLab, Jenkins, etc.. The build server
    should provide a method to get the build number. The build number is used to ensure the release in
    both stores can be related back to the source code that was used to generate the app.
1. Fastlane  
    Fastlane plays two roles:
    1. Building  
    Fastlane builds the ios and android apps and upload them to the respective stores.
        This occurs on the build server.
    1.  Command support  
    Fastlane supports the `start_beta` and `release` commands.
    This occurs on the local machine and triggers the corresponding build processes on the build server.
        

# Setup

The following one-time setup steps are required to enable the workflows provided by `fledge`.

## Application setup
Let's setup your app for automation!
### App name and ID

1. App Name  
The app name, which is what the user sees, should be unique in both stores.
Let's say your app name is `MyUniqueAppName`.

1. App ID  
Decide on an application ID for your app that is unique in both stores. For example, `com.mycompany.todo`. This will be used
in several places to configure this CICD. The application ID does not have to be the same for each
store but it helps keep things simple.

1. Trace-back to source  
To enable the trace-back-to-source feature in `fledge` comment out the `version` in pubspec.yaml
    ```
    # version: 1.0.0+1
    ```

### Optional steps
1. (Optional) Refresh your project  
If you don't already have the latest (or near latest) version of the project set up, it is 
recommended that you build a new project and overlay your new project with your existing
project code. For example:
    ```
    $ flutter create --project-name todo --org com.mycompany todo
    $ cd <my project>
    $ cp -r lib test test_driver pubspec.yaml <location of new project>/todo
    ```
    This is to avoid problems with auto-incrementing the version name for older projects, among
other possibly unforeseen problems (the underlying flutter build environment can change with new
releases).

1. (Optional) Install app icons  
If you have already customized your icons:
    ```
    cd <my project>
    tar cf - android/app/src/main/res ios/Runner/Assets.xcassets | ( cd <location of new project>; tar xf -)
    ```
### Platform specific steps
Since Flutter runs on both iOS and android, there are some platform specific steps during application setup.

#### On android:
1. Update the application id in `android/app/build.gradle`:  

    ````
    applicationId "com.mycompany.todo"
    ````
    
    Note: `versionCode` and `versionName` can be ignored. These are updated automatically by the CICD.
1. Update the app name in `android/app/src/main/AndroidManifest.xml`  
    ```
    android:label="<MyUniqueAppName>"
    ```
    This is the name that appears below the icon on the app.
1. (Recommended) Icons  
To generate a complete set
    of icons from a single image, see https://makeappicon.com. This will generate a complete Asset
    Catalog. Overwrite the existing catalog using:

        cp -r <location of downloaded icons>/android/mipmap* android/app/src/main/res/

#### On ios:
1. Open Xcode. For example:

       open ios/Runner.xcworkspace
    
1. Update the `Display Name` to `MyUniqueAppName`.
1. Update the `Bundle Identifier` to the same as the application id used on android, eg, `com.mycompany.todo`.

    Note: `Version` and `Build` can be ignored. These are updated automatically by the CICD.
1. In `Runner>Runner>Info.plist`, set `Bundle display name` to `MyUniqueAppName`.
1. Disable automatic signing
1. In `Signing (Release)` select the provisioning profile created during match setup.
    For example, use the following provisioning profile:
        
        match AppStore com.mycompany.todo
        
    Note: if match is not already set-up you will have to return to this step after match is set-up.
1. (Recommended) Icons  
Upload will fail if required icons are missing from the Asset Catalog. To generate a complete set
    of icons from a single image, see https://makeappicon.com. This will generate a complete Asset
    Catalog. Overwrite the existing catalog using:

        cp <location of downloaded icons>/ios/AppIcon.appiconset/* ios/Runner/Assets.xcassets/AppIcon.appiconset

## Install `fledge`
`fledge` is a command line utility for installing the CICD dependencies into your project.  

    pub global activate fledge
    
`fledge` is also used to manage betas and releases.  

In the future some steps in this setup may be automated in `fledge` to simplify the task of getting started with CICD.

## Plug app into fledge 
    fledge config -b travis

This command will install fastlane scripts and the config file for Travis

## Fastlane setup
    
1. Modify fastlane metadata to suit your needs.  
This includes changing contact information for both android and ios, changing the name of 
    the app for android and ios (for example, using `MyUniqueAppName`), and many other things.

    The metadata is found under 'android/fastlane/metadata' and 'ios/fastlane/metadata'.

1. Update the `package_name` in `ios/fastlane/Appfile` and `android/fastlane/Appfile` to your 
application ID. For example:
 
        package_name("com.mycompany.todo")


## Google Play Console setup
`App Store Connect` requires that the application be set-up before builds
can be uploaded automatically.

### Create new app in store
    
1. Go to `App Store Connect` (https://play.google.com/apps/publish)

1. Click on `Create Application` and provide a title for your app.  
It is recommended to use the same name in both stores. For example, `MyUniqueAppName`.

1. Provide additional required information 'Short Description', 'Long Description', screenshots, etc...
    - For icon generation try https://makeappicon.com/, https://pub.dartlang.org/packages/flutter_launcher_icons
    
    - For auto screenshot generation see https://pub.dartlang.org/packages/screenshots
    
    - For Feature Graphic generation see https://www.norio.be/android-feature-graphic-generator/

1. When all necessary information is provided, click on `Save Draft`.
1. Complete Content Rating
1. Complete Pricing and Distribution


### Sign android app
An android app requires signing. This is implemented using a private key that you generate yourself.
It is important that you manage this private key carefully. For example, never check it into your
repo.

However, to automate the build, the CICD needs access to this private key. 
This CICD expects to find a password protected encrypted version of the private key in the repo. The
password to unencrypt the private key is provided in the `KEY_PASSWORD` described below.

To learn more about app signing see: https://developer.android.com/studio/publish/app-signing.

Setting-up your app for android signing:  
1. If you do not already have a keystore, generate a new keystore:  

        keytool -genkey -v -keystore android/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
        keytool -importkeystore -srckeystore android/key.jks -destkeystore android/key.jks -deststoretype pkcs12
    
1. Create the `android/key.properties`:  

        storePassword=<store password>
        keyPassword=<key password>
        keyAlias=key
        storeFile=../key.jks

1. Add the following to your `.gitignore`:

        **/android/key.properties
        **/android/key.jks
    
1. Encrypt both files with:
    
        KEY_PASSWORD=<my secret key password>
        openssl enc -aes-256-cbc -salt -in android/key.jks -out android/key.jks.enc -k $KEY_PASSWORD
        openssl enc -aes-256-cbc -salt -in android/key.properties -out android/key.properties.enc -k $KEY_PASSWORD
    
    Remember value of `KEY_PASSWORD` for use in build server setup.

1. Enable android release builds in `android/app/build.gradle`:
    
    Replace:
    ````
    apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
    
    android {
    ````
    with
    ````
    apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
    
    def keystoreProperties = new Properties()
    def keystorePropertiesFile = rootProject.file('key.properties')
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
    }
    
    android {
    ````
    
    and replace:
    ````
        buildTypes {
            release {
                // TODO: Add your own signing config for the release build.
                // Signing with the debug keys for now, so `flutter run --release` works.
                signingConfig signingConfigs.debug
            }
            profile {
                matchingFallbacks = ['debug', 'release']
            }
        }
    ````
    with:
    ````
        signingConfigs {
            release {
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
            }
        }
        buildTypes {
            release {
                signingConfig signingConfigs.release
            }
        }
    ````
1. Push key.jks.enc and key.properties.enc and android/app/build.gradle to the source repo.

    This can be postponed if remote repo is not yet setup.


### Upload first apk

Upload the first apk manually (this is required so `App Store Connect` knows the App ID)
1. Goto `App Releases` and open a beta track. Click on `Manage` and `Edit Release`
1. Click on `Continue` to allow Google to manage app signing key
1. Click on `Browse Files` to upload the current apk (built with `flutter build apk`) from `build/app/outputs/apk/release/app-release.apk`.
1. Discard the beta track using the `Discard` button

## Apple App Store Connect setup
The equivalent steps for the android store have to be taken for the iOS store.

### Sign ios app
Signing is done via Fastlane match.

Configure a private match server from Fastlane.

This requires access to a private repository. You can use a private GitHub repository or
use a private repository from another repository provider, or provide your own.
    
For information on how to set-up a private repo for match see: https://docs.fastlane.tools/actions/match

This CICD does not need the `Matchfile` created during match setup. However, it can be created
temporarily to run the match setup.

Setting-up your app for iOS signing:
1. Initialize match.  
It will ask for the location and write access to the remote private match repo.
    
    ````
    cd ios
    fastlane match init
    ````
    
    This creates a (temporary) file at ios/fastlane/Matchfile.
    
1. Create your app in `App Store Connect`.  
You will be asked for a unique name for the app for end users during this step. It is 
    recommended to use the same name in both stores. For example, `MyUniqueAppName`.

    ````
    fastlane produce -u user@email.com -a com.mycompany.todo -q MyUniqueAppName
    ````
    
    See https://docs.fastlane.tools/actions/produce for details.
    
1. Sync the match repo with the app store.
    ````
    fastlane match appstore
    ````
    
   Among other things, this will create a provisioning profile that is used during app setup above. For example, `match AppStore com.mycompany.todo`. Go back to app setup to complete this step for ios.
1. Delete the Matchfile (as it contains secure info)

### Create required images

`App Store Connect` requires the following images:

1. Screenshots  
Screenshots must be included in upload for iOS. Screenshots can be generated automatically (for
    both android and ios) using https://pub.dartlang.org/packages/screenshots. Alternatively
    they can be generated manually.

1. App Store Icon  
iOS Apps must include a 1024x1024px App Store Icon in PNG format.
    
    See https://makeappicon.com/

    Store in `ios/fastlane/metadata/app_icon.png`
    
1. App Store Icon for iPad  
Since flutter supports iPad, a related app icon is required of exactly '167x167' pixels, 
    in .png format for iOS versions supporting iPad Pro (which is all flutter apps).
    
## Repo server setup
Assuming you have an empty remote repo:
1. Commit files on your local repo
1. Create a `dev` branch on your local repo

        git checkout -b dev

1. Push your local repo to the remote repo.

        git push --set-upstream origin dev

1. (Recommended) Protect master branch  
On the repo server, it is recommended to set the `master` branch to protected and `dev` as the default branch. This is to prevent accidental manual pushes to the `master` branch.

    After this point
the remote `master` should be protected and should never be pushed-to manually. There should never
be a reason to even checkout the local `master` branch locally. 
For example, see https://help.github.com/articles/setting-the-default-branch and https://help.github.com/articles/configuring-protected-branches.

    All CICD commands should only then be issued from
the local `dev` branch (`fledge` will guarantee this).

## Build server setup

1. Account config  
If your Apple ID under your Apple Developer Account has 2-factor authentication enabled, 
you must create a new Apple ID without 2-factor authentication. This can be done using your
existing Apple Developer account. See https://appstoreconnect.apple.com/access/users. It should
be set to have access to your app in `App Store Connect`. Log out and log back in, using your
 new Apple ID, to complete
the setup of your new Apple ID.

1. (Optional) Connect to build server  
To complete the connection between Travis and GitHub, you may have to sync your account on Travis and enable the GitHub repo. See: https://travis-ci.org/account/repositories

1. Secret variables  
Add the following secret variables to your preferred build server (Travis, or GitLab, etc... ):

    ```
        FASTLANE_USER
        FASTLANE_PASSWORD
        GOOGLE_DEVELOPER_SERVICE_ACCOUNT_ACTOR_FASTLANE
        KEY_PASSWORD
        PUBLISHING_MATCH_CERTIFICATE_REPO
        MATCH_PASSWORD
    ```
    
    * FASTLANE_USER  
    This is your Apple ID (without 2-factor authentication). For example, user@email.com.
    
    * FASTLANE_PASSWORD  
    This is your Apple ID password. For travis, if there are special characters the
        password should be enclosed in single quotes.
        
    * GOOGLE_DEVELOPER_SERVICE_ACCOUNT_ACTOR_FASTLANE  
    This is required to login to `Google Play Console`. This is a private key. It should be
        surrounded with single quotes to be accepted by Travis. It can be generated on 
        https://console.developers.google.com. Note: this should never be included in your repo.
        
    * KEY_PASSWORD  
    This is the password to the encrypted app private key stored in `android/key.jks.enc` and
        the related encrypted properties files stored in `android/key.properties.enc`
        
    * PUBLISHING_MATCH_CERTIFICATE_REPO  
    This is the location of the private match repo. For example, https://private.mycompany.com/private_repos/match
     
    * MATCH_PASSWORD  
    The password used while setting up match.
        
# Usage

## Starting a beta for both android and ios

To start a beta:

1. Commit local dev  
    Make sure you are in the dev directory and all files are committed.
1. Then enter:
    ```
    $ fledge beta
    ```

    This will increment the semver version name, generate a git tag, and push the committed code in the local `dev` to the remote `dev`. This push will trigger the build server to build the app
for ios and android and deploy each build to beta testers 
automatically on both stores.

When ready to start a new beta simply commit the code for the next beta to the local `dev` and
re-issue the `fledge beta` command.

### Semver
The semver version name can be incremented using:

    fastlane start_beta patch (the default)
    fastlane start_beta minor
    fastlane start_beta major
    
## Release to both stores

When you are satisfied that the latest beta is complete it is time to make a release. At this point, your local dev branch has been synced to the remote dev branch and the build artifact is already in both stores. So making a release involves promoting the build in the beta track in both stores to a release.

1. Enter:
    ```
    $ fledge release
    ```

    This will confirm that the local `dev` is committed locally and as a precaution it confirms that no
push is required from the local `dev` to the remote `dev`. Then it will merge the remote `dev` to 
the remote `master`. This will 
trigger the build server to promote each build used in beta testing to a release in both stores. 
The remote `master` now contains the most current code (the code used in the build that went thru
beta testing).

    A rebuild of the beta-tested build is not required because the build artifact is already present in both stores.

Note: currently `fledge` auto-release is disabled in both stores. So the final step to release should be completed manually thru each store console.

# The CI part of CICD
Note: Only the CD (Continous Delivery) part of CICD is currently implemented. Unit testing would be relatively
easy to add to this setup. Integration testing involves adding emulators and simulators which 
requires more setup.

For a live example of
CI (Continous Integration) for Flutter, including unit and integration testing in the cloud,
see https://github.com/brianegan/flutter_architecture_samples.

Support for CI (Continuous Integration) will be added in an upcomming release of `fledge`.`

# Issues and Pull Requests
This is an initial release and more features will be added in upcomming releases.

[Issues](https://github.com/mmcc007/screenshots/issues) and [pull requests](https://github.com/mmcc007/screenshots/pulls) are welcome.

