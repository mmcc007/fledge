---
layout: default
title: Build Server Configuration
nav_order: 8
---

# Build Server Configuration
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

### Secret variables 
Secret variables are passed into the pipeline by the build server during a Fledge pipeline run. 

Secret variables are never exposed by the build server in the logs (or anywhere else).
 
Add the following secret variables to your preferred build server (Travis, or GitLab, etc... ):

```
FASTLANE_USER
FASTLANE_PASSWORD
GOOGLE_DEVELOPER_SERVICE_ACCOUNT_ACTOR_FASTLANE
KEY_PASSWORD
PUBLISHING_MATCH_CERTIFICATE_REPO
MATCH_PASSWORD
```
    
* FASTLANE_USER  
This is your Apple ID (without 2-factor authentication). For example, user@email.com.
    
* FASTLANE_PASSWORD  
This is your Apple ID password. For travis, if there are special characters the password should be enclosed in single quotes.
        
* GOOGLE_DEVELOPER_SERVICE_ACCOUNT_ACTOR_FASTLANE  
This is required to login to `Google Play Console`. This is a private key. It should be surrounded with single quotes to be accepted by Travis.

Follow these steps to create your private key:
1. Open the [Google Play Console](https://play.google.com/apps/publish/)
2. Click the _Settings_ menu entry, followed by _API access_
3. Click the _CREATE SERVICE ACCOUNT_ button
4. Follow the _Google Developers Console_ link in the dialog, which opens a new tab/window:
   1. Click the _CREATE SERVICE ACCOUNT_ button at the top of the _Google Developers Console_
   2. Provide a `Service account name`
   3. Click _Select a role_ and choose _Service Accounts > Service Account User_
   4. Check the _Furnish a new private_ key checkbox
   5. Make sure _JSON_ is selected as the Key type
   6. Click _SAVE_ to close the dialog
   7. Make a note of the file name of the JSON file downloaded to your computer
5. Back on the _Google Play Console_, click _DONE_ to close the dialog
6. Click on _Grant Access_ for the newly added service account
7. Choose _Release Manager_ (or alternatively _Project Lead_) from the Role dropdown. (Note that choosing _Release Manager_ grants access to the production track and all other tracks. Choosing _Project Lead_ grants access to update all tracks except the production track.)
8. Click _ADD USER_ to close the dialog

Note: this should never be included in your repo.
        
* KEY_PASSWORD  
This is the password to the encrypted app private key stored in `android/key.jks.enc` and the related encrypted properties files stored in `android/key.properties.enc`
        
* PUBLISHING_MATCH_CERTIFICATE_REPO  
This is the location of the private match repo. For example, https://myusername:mypassword@private.mycompany.com/private_repos/match
     
* MATCH_PASSWORD  
The password used while setting up match to unencrypt the certificates.

## Travis
1. Secret variables  
Add secret variables in the Travis console for your app at:
```
https://travis-ci.org/<your name>/<app repo>/settings
```
![secret variables](../../assets/images/travis_secret_env.png)  
<small>These variables are used for signing and uploading to both stores.</small>

1. _Optional_: Connect to build server  
To complete the connection between Travis and GitHub, you may have to sync your account on Travis and enable the GitHub repo. See: [https://travis-ci.org/account/repositories](https://travis-ci.org/account/repositories).

## In-house GitLab
1. Secret variables  
Add secret variables in the in-house GitLab console for your app at:
```
https://gitlab.mycompany.com/<your name>/<app repo>/settings/ci_cd
```
![secret variables](../../assets/images/gitlab_inhouse_secret_env.png)  
<small>These variables are used for signing and uploading to both stores.</small>
