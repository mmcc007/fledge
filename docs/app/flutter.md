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
Decide on an Application ID for your app that is unique in both stores. For example, `com.mycompany.todo`.
1. Pick an App Name  
The app name, which is what the user sees, should be unique in both stores. Let's say your app name is `MyUniqueAppName`.

## Version tracking  
The build number and release tag change with each build and release of the app. It is useful to be able to embed these values in the build artifact. This allows tracing-back from any version of the app, running on any device, to the build and source code.  
To enable build and release tracking comment-out the version in your pubspec.yaml:
```yaml
# version: 1.0.0+1
```