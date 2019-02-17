---
layout: default
title: Google Store
parent: Stores Configuration
nav_order: 2
---

# Google Store Configuration
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Google Play Console

All android apps must be setup in `Google Play Console` before builds can be uploaded automatically.

### Create new app in store
    
1. Go to `Google Play Console` ([https://play.google.com/apps/publish](https://play.google.com/apps/publish))

1. Click on `Create Application` and provide a title for your app.  
It is recommended to use the same name in both stores. For example, `MyUniqueAppName`.

1. Provide additional required information 'Short Description', 'Long Description', screenshots, etc...
    - For icon generation see [https://makeappicon.com/](https://makeappicon.com/), [https://pub.dartlang.org/packages/flutter_launcher_icons](https://pub.dartlang.org/packages/flutter_launcher_icons)
    
    - For auto screenshot generation see [https://pub.dartlang.org/packages/screenshots](https://pub.dartlang.org/packages/screenshots)
    
    - For Feature Graphic generation see [https://www.norio.be/android-feature-graphic-generator/](https://www.norio.be/android-feature-graphic-generator/)

1. When all necessary information is provided, click on `Save Draft`.
1. Complete Content Rating
1. Complete Pricing and Distribution

### Upload first apk

Upload the first apk manually (this is required so `App Store Connect` knows the App ID)
1. Goto `App Releases` and open a beta track. Click on `Manage` and `Edit Release`
1. Click on `Continue` to allow Google to manage app signing key
1. Click on `Browse Files` to upload the current apk (built with `flutter build apk`) from `build/app/outputs/apk/release/app-release.apk`.
1. Discard the beta track using the `Discard` button

---
