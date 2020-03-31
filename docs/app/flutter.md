---
layout: default
title: Flutter
parent: App Configuration
nav_order: 1
---

# Flutter
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

Decide on consistent identifiers for your Flutter app. These identifiers will be used throughout the configuration of the Flutter, Android and iOS components of your app.

## App ID and App Name
The App ID and App Name are identifiers used by both stores. 

Separate identifiers can be used in each store. However, to make things simple, it is recommended to use the same identifiers in both stores.
 
These identifiers will be used in several places to configure the app for release.
 
1. Pick an App ID  
Decide on an Application ID for your app that is unique in both stores. For example, `com.mycompany.myapp`.
1. Pick an App Name  
The app name, which is what the user sees, should be unique in both stores. Let's say your app name is `MyUniqueAppName`.
1. Update Fastlane config with the Application ID

   - `ios/fastlane/Appfile`: 
       ```
       app_identifier("com.mycompany.myapp")
       ```  
   -  `android/fastlane/Appfile`:
       ```
       package_name("com.mycompany.myapp")
       ```  

## Version tracking  
The build number and release tag change with each build and release of the app. It is useful to be able to embed these values in the build artifact. This allows tracing-back from any version of the app, running on any device, to the build and source code.  
To enable build and release tracking comment-out the version in your pubspec.yaml:
```yaml
# version: 1.0.0+1
```

## Optional steps
1. _Optional_: Refresh your project  
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

1. _Optional_: Install app icons  
If you have already customized your icons:
```
$ cd <my project>
$ tar cf - android/app/src/main/res ios/Runner/Assets.xcassets | ( cd <location of new project>; tar xf -)
```

---