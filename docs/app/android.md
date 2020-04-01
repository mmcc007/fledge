---
layout: default
title: Android
parent: App Configuration
nav_order: 2
---

# Android
{: .no_toc }

The App ID, App Name, icons and signing should be set in the android config files.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

### App ID
Update the application id in `android/app/build.gradle`:  
````
applicationId "com.mycompany.myapp"
````
    
Note: `versionCode` and `versionName` can be ignored. These are updated automatically by Fledge.

### App Name
Update the app name in `android/app/src/main/AndroidManifest.xml`  
```
android:label="<MyUniqueAppName>"
```
This is the name that appears below the icon on the app.

### App Icons
The set of icons, required for an Android app, can be generated in a number of different ways.
For one way to generate a complete set of icons from a single image, see [https://makeappicon.com](https://makeappicon.com). This will generate an set if icons for Android. Overwrite the existing catalog using:
```
cp -r <location of downloaded icons>/android/mipmap* android/app/src/main/res/
```
See also: [https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html)

### App Signing

An android app requires signing using a private key that you generate yourself.
It is important that you manage this private key carefully. For example, never check it into your repo.

To learn more about app signing see: [https://developer.android.com/studio/publish/app-signing](https://developer.android.com/studio/publish/app-signing).

Some of the following steps were taken from:  
https://flutter.dev/docs/deployment/android

Setting-up your app for android signing:  
1. Generate a new keystore for your app. You will be asked for a `store password` and `key password`, remember them for next step:  

        keytool -genkey -v -keystore android/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
        keytool -importkeystore -srckeystore android/key.jks -destkeystore android/key.jks -deststoretype pkcs12
    
1. Create the `android/key.properties`:  

        storePassword=<store password>
        keyPassword=<key password>
        keyAlias=key
        storeFile=../key.jks

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

1. Confirm you can build a signed release without error
    ```
    flutter build apk --release
    ```
    or
    ```
    flutter build appbundle --release
    ```
    
1. Encrypt both files with:
    
        KEY_PASSWORD=<my secret key password>
        openssl enc -aes-256-cbc -salt -in android/key.jks -out android/key.jks.enc -k $KEY_PASSWORD
        openssl enc -aes-256-cbc -salt -in android/key.properties -out android/key.properties.enc -k $KEY_PASSWORD
    
    Remember value of `KEY_PASSWORD` for use in build server setup.

1. Add the following to your `.gitignore`:

       **/android/key.properties
       **/android/key.jks

1. Commit key.jks.enc and key.properties.enc and android/app/build.gradle.

---
