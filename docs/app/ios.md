---
layout: default
title: iOS
parent: App Configuration
nav_order: 3
---

# iOS
{: .no_toc }

The App ID, App Name, icons and signing should be set in the iOS config files.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

Open Xcode
```
open ios/Runner.xcworkspace
```

### App ID
Update the `Bundle Identifier` to the same as the application id used on android, eg, `com.mycompany.todo`.

Note: `Version` and `Build` can be ignored. These are updated automatically by the Fledge.

### App Name
1. Update the `Display Name` to `MyUniqueAppName`.
1. In `Runner>Runner>Info.plist`, set `Bundle display name` to `MyUniqueAppName`.

### App Icons  
To generate a complete set of icons from a single image, see [https://makeappicon.com](https://makeappicon.com). This will generate a complete Asset
    Catalog. Overwrite the existing catalog using:
```
cp <location of downloaded icons>/ios/AppIcon.appiconset/* ios/Runner/Assets.xcassets/AppIcon.appiconset
```

### App Signing
Signing is done via Fastlane match and requires a private repository.

There are a variety of options to setup a private repository. You can use a private repository from GitHub (for free) or from another repository provider, or provide your own.
    
For information on how to set-up a private repo for match see: [https://docs.fastlane.tools/actions/match](https://docs.fastlane.tools/actions/match)

Setting-up your app for iOS signing:
1. Initialize match.  
It will ask for the location and write access to the remote private match repo.
    
    ````
    cd ios
    fastlane match init
    ````
   
    This creates a (temporary) file at ios/fastlane/Matchfile.

    Remember the following match values for use in configuring as secret variables in the build server
    1. The url of your private repository  
    `PUBLISHING_MATCH_CERTIFICATE_REPO`
    1. The user/pass to access the private repository  
    This is embedded in `PUBLISHING_MATCH_CERTIFICATE_REPO`
    1. The password to unencrypt the match certificates  
    `MATCH_PASSWORD`


1. Create your app in `App Store Connect`.  
You will be asked for a unique name for the app for end users during this step. It is 
    recommended to use the same name in both stores. For example, `MyUniqueAppName`.

    ````
    fastlane produce -u user@email.com -a com.mycompany.todo -q MyUniqueAppName
    ````
    
    See [https://docs.fastlane.tools/actions/produce](https://docs.fastlane.tools/actions/produce) for details.
    
1. Sync the match repo with the app store.
    ````
    fastlane match appstore
    ````
    
   Among other things, this will create a provisioning profile that is used during app setup above. For example, `match AppStore com.mycompany.todo`.
1. Delete the Matchfile (as it contains secure info)

In Xcode:

Go to `Signing (Release)` and select the provisioning profile created during match setup.
For example, use the following provisioning profile:        
```
match AppStore com.mycompany.todo
```    

---

