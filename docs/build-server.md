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
Secret variables are passed into the pipeline by the build server during a Fletch pipeline run. 

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
This is required to login to `Google Play Console`. This is a private key. It should be surrounded with single quotes to be accepted by Travis. It can be generated on [https://console.developers.google.com](https://console.developers.google.com). 

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