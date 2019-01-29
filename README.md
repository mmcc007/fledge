[![pub package](https://img.shields.io/pub/v/fledge.svg)](https://pub.dartlang.org/packages/fledge)

# CICD for Flutter

See [article](https://medium.com/@nocnoc/cicd-for-flutter-fdc07fe52abd) for introduction to `fledge`.

Note: for demo of `fledge` see [todo](https://github.com/mmcc007/todo) which shows 
`fledge` in use to deliver an app to both the Apple and Google stores. The app is live in both stores.

CICD is 'Continous Interation and Continous Delivery'. It is the idea of allowing developers
to focus on developing and reducing time spent on repetitive tasks, such as testing and 
delivery, using automation. For more details see ([CICD](https://en.wikipedia.org/wiki/CI/CD)).

This particular implementation of CICD is a slightly opinionated approach to CICD that 
seems to work well with Flutter.

The idea of this implementation of CICD is to do all development in a `dev` branch and when 
ready for beta, do a beta release
to both `Google Play Console` and `App Store Connect`. 

Each time a new beta is ready, a 'start beta' command is issued and a new beta is started 
and automatically released to testers.

Then when beta testing is complete, a 'release' command is issued and the `dev` branch is automatically 
merged with the `master` branch and the release is uploaded to the `Apple Store` and the 
Google `Play Store`.

In this way it is guaranteed that:
 1. The apps built for iOS and Android always have the same version name
and build number. 
2. The build used to pass beta testing is the same build that is shipped to the stores. No rebuild
required.
3. Using the version name (or the build number), the build can be traced back to the source used in the build.
    
    The version name is the git tag, which tags the code used in the build. Alternatively the 
    build server records the commit ID used in the build next to the build number.
4. The app name, version name, and build number can be displayed in an About section of the shipped 
app for support and bug fixing. These values will be the same on both android and ios.
5. As an additional bonus, a beta can be started and the apps released to both stores in as long 
as it takes the build server to run. This can be as fast as 15 minutes (not including Apple's 
review time).

A by-product of this is that, if your build server supports macs, a development mac is not 
required (except perhaps for setting-up match and for [screenshots](https://pub.dartlang.org/packages/screenshots)). Development can be done 
on Windows or Linux. The build server will take care of the ios-specific details of 
building the ios app, starting the ios beta and release to `Apple Store`.
 
Table of Contents
=================

   * [CICD for Flutter](#cicd-for-flutter)
   * [Table of Contents](#table-of-contents)
   * [Implementation](#implementation)
   * [Setup](#setup)
      * [Application setup](#application-setup)
      * [Install fledge](#install-fledge)
      * [Install CICD dependencies](#install-cicd-dependencies)
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
2. Build Server    
    The build server can be provided by Travis, Cirrus, an internal server running GitLab, Jenkins, etc.. The build server
    should provide a method to get the build number. The build number is used to ensure the release in
    both stores can be related back to the source code that was used to generate the app.    
3. Fastlane    
    Fastlane plays two roles: 
    1. To build the ios and android apps and upload them to the respective stores.    
        This occurs on the build server.
    1. To implement the `start_beta` and `release` command    
        This occurs on the local machine and triggers the corresponding processes on the build server.
        
As an optional sanity test, before setting-up CICD for your own app, clone this repo and deploy it
by following all the setup steps.

# Setup

There are a lot of setup steps to take to get this working. But keep in mind that this only has
to be done once. 

Many of these steps have to be taken anyway to release an app. So I figured... may as well gather
all these steps into one place and add some automation!

If you want to do beta testing and releases on demand, it is well worth the effort!

## Application setup

Decide on an application ID for your app that is unique in both stores. For example, `com.mycompany.todo`. This will be used
in several places to configure this CICD. The application ID does not have to be the same for each
store but it helps keep things simple.

If you don't already have the latest (or near latest) version of the project set up, it is 
recommended that you build a new project and overlay your new project with your existing
project code. For example:

    flutter create --project-name todo --org com.mycompany todo
    cd <my project>
    cp -r lib test test_driver pubspec.yaml <location of new project>/todo

This is to avoid problems with auto-incrementing the version name for older projects, among
other possibly unforeseen problems (the underlying flutter build environment can change with new
releases).

To enable CICD-managed version control comment out the `version` in pubspec.yaml

    # version: 1.0.0+1

If you have already customized your icons:

    cd <my project>
    tar cf - android/app/src/main/res ios/Runner/Assets.xcassets | ( cd <location of new project>; tar xf -)

As with any mobile app, the following changes are required.

On android:

1. Update the application id in `android/app/build.gradle`:

    ````
    applicationId "com.mycompany.todo"
    ````
    
    `versionCode` and `versionName` can be ignored. These are updated automatically by the CICD.

On ios:

1. Open Xcode. For example:

        open ios/Runner.xcworkspace
    
1. Using XCode update the `Display Name` to the name the user will see.
2. Using XCode update the `Bundle Identifier` to the same as the application id used on android, eg, `com.mycompany.todo`.

    `Version` and `Build` can be ignored. These are updated automatically by the CICD.
3. Disable automatic signing
4. In `Signing (Release)` select the provisioning profile create during match setup. 
    For example, use the following provisioning profile:
        
        match AppStore com.mycompany.todo
        
    Note: if match is not already set-up you will have to return to this step after match is set-up.

Note: if not on a mac, these changes can be made directly in the ios config files. This process
is not currently documented in this README.

## Install `fledge`
`fledge` is a command line utility for installing the CICD dependencies into your project.  

    pub global activate fledge
    
'fledge' is also used to manage betas and releases.  
Some steps in this setup may be automated in `fledge` to simplify the task of getting started with CICD.

## Install CICD dependencies  
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
can be uploaded automatically. Therefore, you should take the following steps:

### Create new app in store
    
1. Go to `App Store Connect` (https://play.google.com/apps/publish)
 
3. Click on `Create Application` and provide a title for your app. 
    
    It is recommended to use the same name in both stores. For example, `MyUniqueAppName`.

4. Provide additional required information 'Short Description', 'Long Description', screenshots, etc...

    For icon generation try https://makeappicon.com/, https://pub.dartlang.org/packages/flutter_launcher_icons
    
    For auto screenshot generation see https://pub.dartlang.org/packages/screenshots
    
    For Feature Graphic generation see https://www.norio.be/android-feature-graphic-generator/

5. When all necessary information is provided, click on `Save Draft`. 
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
 
1. If you do not already have a keystore, generate a new keystore:

        keytool -genkey -v -keystore android/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
        keytool -importkeystore -srckeystore android/key.jks -destkeystore android/key.jks -deststoretype pkcs12
        rm android/key.jks.old
    
2. Create the `android/key.properties`:

        storePassword=<store password>
        keyPassword=<key password>
        keyAlias=key
        storeFile=../key.jks

Then encrypt them as follows:
1. Add the following to your `.gitignore`:

        **/android/key.properties
        **/android/key.jks
    
2. Encrypt both files with:
    
        KEY_PASSWORD=<my secret key password>
        openssl enc -aes-256-cbc -salt -in android/key.jks -out android/key.jks.enc -k $KEY_PASSWORD
        openssl enc -aes-256-cbc -salt -in android/key.properties -out android/key.properties.enc -k $KEY_PASSWORD
    
    Remember value of `KEY_PASSWORD` for use in build server setup.

3. Enable android release builds in `android/app/build.gradle`:
    
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
3. Push key.jks.enc and key.properties.enc and android/app/build.gradle to the source repo.

    This can be postponed if remote repo is not yet setup.


### Upload first apk

Upload the first apk manually (this is required so `App Store Connect` knows the App ID)
1. Goto `App Releases` and open a beta track. Click on `Manage` and `Edit Release`
2. Click on `Continue` to allow Google to manage app signing key
3. Click on `Browse Files` to upload the current apk (built with `flutter build apk`) from `build/app/outputs/apk/release/app-release.apk`.
4. Discard the beta track using the `Discard` button

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
1. Initialize match. 
    It will ask for the location and write access to the remote private match repo.
    
    ````
    fastlane match init
    ````
    
    This creates a (temporary) file at ios/fastlane/Matchfile.
    
2. Create your app in `App Store Connect`. 

    You will be asked for a unique name for the app for end users during this step. It is 
    recommended to use the same name in both stores. For example, `MyUniqueAppName`.

    ````
    fastlane produce -u user@email.com -a com.mycompany.todo -q MyUniqueAppName
    ````
    
    See https://docs.fastlane.tools/actions/produce for details.
    
3. Sync the match repo with the app store.

    ````
    fastlane match appstore
    ````
    
   Among other things, this will create a provisioning profile that is used during app setup above. For example, `match AppStore com.mycompany.todo`. Go back to app setup to complete this step for ios.
4. Delete the Matchfile (as it contains secure info)

### Create required images
1. Icons

    Upload will fail if required icons are missing from the Asset Catalog. To generate a complete set
    of icons from a single image, see https://makeappicon.com. This will generate a complete Asset
    Catalog. Overwrite the existing catalog using:

        cp <location of downloaded icons>/ios/AppIcon.appiconset/* ios/Runner/Assets.xcassets/AppIcon.appiconset
        
2. Screenshots

    Screenshots must be included in upload. Screenshots can be generated automatically (for
    both android and ios) using https://pub.dartlang.org/packages/screenshots. Alternatively
    they can be generated manually.

1. App Store Icon

    iOS Apps must include a 1024x1024px App Store Icon in PNG format.
    
    See https://makeappicon.com/

    Store in `ios/fastlane/metadata/app_icon.png`
    
2. App Store Icon for iPad

    Since flutter supports iPad, a related app icon is required of exactly '167x167' pixels, 
    in .png format for iOS versions supporting iPad Pro (which is all flutter apps).
    
## Repo server setup
Assuming you have an empty remote repo:
1. Commit files on your local repo
2. Create a `dev` branch on your local repo

        git checkout -b dev

3. Push your local repo to the remote repo.

        git push --set-upstream origin dev

4. On the repo server, it is recommended to set the `master` branch to protected and `dev` as the default branch. This is to prevent accidental manual pushes to the `master` branch.

After this point
the remote `master` should be protected and should never be pushed-to manually. There should never
be a reason to even checkout the local `master` branch locally. 
For example, see https://help.github.com/articles/setting-the-default-branch and https://help.github.com/articles/configuring-protected-branches.

All CICD commands should be issued from
the local `dev` branch.

## Build server setup

If your Apple ID under your Apple Developer Account has 2-factor authentication enabled, 
you must create a new Apple ID without 2-factor authentication. This can be done using your
existing Apple Developer account. See https://appstoreconnect.apple.com/access/users. It should
be set to have access to your app in `App Store Connect`. Log out and log back in, using your
 new Apple ID, to complete
the setup of your new Apple ID.

To complete the connection between Travis and GitHub, you may have to sync your account on Travis and enable the GitHub repo. See: https://travis-ci.org/account/repositories

Add the following secret variables to your preferred build server (Travis, or GitLab, etc... ):


    FASTLANE_USER
    FASTLANE_PASSWORD
    GOOGLE_DEVELOPER_SERVICE_ACCOUNT_ACTOR_FASTLANE
    KEY_PASSWORD
    PUBLISHING_MATCH_CERTIFICATE_REPO
    MATCH_PASSWORD
    
   * FASTLANE_USER
        This is your Apple ID (without 2-factor authentication). For example, user@email.com.
    
   * FASTLANE_PASSWORD
        This is your Apple ID password. For travis, if there are special characters the 
        password should be enclosed in single quotes.
        
   * GOOGLE_DEVELOPER_SERVICE_ACCOUNT_ACTOR_FASTLANE
        This is required to login to `Google Play Console`. This is a private key. It should be
        surround with single quotes to be accepted by Travis. It can be generated on 
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

Make sure you are in the dev directory in root of repo (and all files are committed and uploaded to remote). Then enter:

    fledge beta


This will increment the semver version name, generate a git tag, and push the committed code in the local `dev` to the remote `dev`. This push will trigger the build server to build the app 
for ios and android and deploy each build to beta testers 
automatically on both stores.

When ready to start a new beta simply merge the code for the next beta to the local `dev` and
re-issue the command.

The semver version name can be incremented using:

    fastlane start_beta patch (the default)
    fastlane start_beta minor
    fastlane start_beta major
    
## Release to both stores

To release to both stores, from root of local repo, in the `dev` branch, enter:

    fledge release


This will confirm that the local `dev` is committed locally and as a precaution it confirms that no
push is required from the local `dev` to the remote `dev`. Then it will merge the remote `dev` to 
the remote `master`. This will 
trigger the build server to promote each build used in beta testing to a release in both stores. 
The remote `master` now contains the most current code (the code used in the build that went thru
beta testing). A rebuild of the beta-tested build is not required.

Note: currently auto-release is disabled in both stores. So the last step to release will have to
be completed manually for each store.

# The CI part of CICD
Only the CD (Continous Delivery) part of CICD is currently addressed here. For an example of the
CI (Continous Integration) part, including unit and integration testing in the cloud, 
see https://github.com/brianegan/flutter_architecture_samples. Unit testing would be relatively
easy to add to this setup. Integration testing involves adding emulators and simulators which 
requires more setup.

# Issues and Pull Requests
There are several possibilities for improvement. Only the [happy path](https://en.wikipedia.org/wiki/Happy_path) is currently working and a few other things. So feedback is very welcome.

