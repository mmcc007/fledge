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
    app_identifier("<eg, com.mycompany.todo>")
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
    package_name("<eg, com.mycompany.todo>")
    ```

## Apple Account config  

If your Apple ID under your Apple Developer Account has 2-factor authentication enabled, Fastlane will require a new Apple ID without 2-factor authentication. 

A new Apple ID can be created using your existing Apple Developer account. See [https://appstoreconnect.apple.com/access/users](https://appstoreconnect.apple.com/access/users). It should be set to have access to your app in `App Store Connect`. 

To complete the setup of your new Apple ID, it is important that you log out and log back in, using your new Apple ID. When logging back-in you will be prompted to setup security questions and answers. This is required as part of the normal account setup process for your new Apple ID. 

The Apple ID's username and password are used by the build server secret variables `FASTLANE_USER` and `FASTLANE_PASSWORD`.

---
