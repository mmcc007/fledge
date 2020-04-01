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
Note: Fledge has no local dependency on Fastlane, so it is not necessary to install Fastlane on your local machine.

### Metadata updates
Metadata is the extra information about the app required by both stores. Fastlane maintains the metadata of the app and uploads it to both stores during a Fledge pipeline run.

Modify the Fastlane metadata to suit your needs.  
This includes changing contact information required by both Google and Apple, changing the name of 
    the app for android and ios (for example, using `MyUniqueAppName`), and other metadata.

The metadata is found under 'android/fastlane/metadata' and 'ios/fastlane/metadata'.

### Appfile updates
For iOS, make the following changes to the Appfile in `ios/fastlane/Appfile:
1. Update the `app_identifier`:
    ```
    app_identifier("<eg, com.mycompany.myapp>")
    ```
1. Update the `itc_team_id`:  
    ```
    itc_team_id("<eg, 118607454>") # App Store Connect Team ID
    ``` 
1. Update the `team_id`:  
    ```
    team_id("<eg, ET2VMHJPVM>") # Developer Portal Team ID
    ```

For android, make the following changes to the Appfile in `android/fastlane/Appfile`:
1. Update the `package_name`:
    ```
    package_name("<eg, com.mycompany.myapp>")
    ```

## Apple Account config  

If your Apple ID under your Apple Developer Account has 2-factor authentication (2FA) enabled, Fastlane will not work in a CI environment. 

There are at lease two methods for getting around 2FA, one of which is currently supported by Fledge.

1. A new Apple ID without 2FA (supported) 

    A new Apple ID can be created using your existing Apple Developer account. See [https://appstoreconnect.apple.com/access/users](https://appstoreconnect.apple.com/access/users). It should be set to have access to your app in `App Store Connect`. 
 
    When creating a new account, you will need to supply another email address. An invitation is sent to that address, which you must use to create a new account. During account creation, you will have to provide a password and three security questions. Two security questions must be answered every time you log in on the apple website because you don't have 2 step verification enabled. Don't worry though: these questions are not triggered when you use the account in a scripted environment like Fledge.

    Warning: NEVER enable 2 step verification for this account. Once you turn it on, it cannot be turned off again.

    The Apple ID's username and password are used by the build server secret variables `FASTLANE_USER` and `FASTLANE_PASSWORD`.
    
1. Application specific password (not supported)  
Using your default Apple ID, it is possible to generate an application specific password. To create the password go to https://appleid.apple.com/account/manage.
Add the password to `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`  
Note: at some point may switch to this method as it is more straightforward.

---
