---
layout: default
title: Fastlane Configuration
nav_order: 5
---

# Fastlane Configuration
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

### Installing Fastlane
Install fastlane using
```
# Using RubyGems
sudo gem install fastlane -NV

# Alternatively using Homebrew
brew cask install fastlane
```

### Metadata
Metadata is the extra information about the app required by both stores. Fastlane maintains the metadata of the app and uploads it to both stores during a Fledge pipeline run.

Modify the Fastlane metadata to suit your needs.  
This includes changing contact information required by both Google and Apple, changing the name of 
    the app for android and ios (for example, using `MyUniqueAppName`), and other metadata.

The metadata is found under 'android/fastlane/metadata' and 'ios/fastlane/metadata'.

### App ID
Update the `package_name` in `ios/fastlane/Appfile` and `android/fastlane/Appfile` to your 
application ID. For example:
```
package_name("com.mycompany.todo")
```

## Apple Account Config  

If your Apple ID under your Apple Developer Account has 2-factor authentication enabled, Fastlane will require a new Apple ID without 2-factor authentication. 

A new Apple ID can be created using your existing Apple Developer account. See [https://appstoreconnect.apple.com/access/users](https://appstoreconnect.apple.com/access/users). It should be set to have access to your app in `App Store Connect`. 

To complete the setup of your new Apple ID, log out and log back in, using your new Apple ID.

The Apple ID's username and password are used by the build server secret variables `FASTLANE_USER` and `FASTLANE_PASSWORD`.

---
