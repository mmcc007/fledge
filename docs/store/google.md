---
layout: default
title: Google Store
parent: Store Configuration
nav_order: 2
---

# Google Store Configuration
{: .no_toc }
All android apps must be setup in `Google Play Console` before builds can be uploaded automatically.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
### Screenshots
For auto screenshot generation see [https://pub.dartlang.org/packages/screenshots](https://pub.dartlang.org/packages/screenshots)

### Create new app in store
    
1. Go to `Google Play Console` ([https://play.google.com/apps/publish](https://play.google.com/apps/publish))

1. Click on `Create Application` and provide a title for your app.  
It is recommended to use the same name in both stores. For example, `MyUniqueAppName`.

1. Provide additional required information 'Short Description', 'Long Description', store graphics, etc...
For Feature Graphic generation see [https://www.norio.be/android-feature-graphic-generator](https://www.norio.be/android-feature-graphic-generator)  


1. When all necessary information is provided, click on `Save Draft`.

1. Complete Content Rating (requires an .apk)

1. Complete Pricing and Distribution

### Enable automatic uploads
Google Play Console requires uploading the app for the first time manually. 
(AFAIK this is required so `Google Play Console` knows the App ID). We will use the beta track to do the upload and then delete it when done. Fledge will be able to do uploads automatically after this.

1. Goto `App Releases` and open a beta track. Click on `Manage` and `Create Release`

1. Click on `Continue` to allow Google to manage app signing key

1. Click on `Browse Files` to upload either  
a) the current apk (built with `flutter build apk`) from `build/app/outputs/apk/release/app-release.apk`.  
or  
b) the current aab (built with `flutter build bundle`) from `build/app/outputs/bundle/release/app-release.aab`.

1. Discard the pending beta track release using the `Discard` button  
(since fledge uses the alpha track by default)

---
