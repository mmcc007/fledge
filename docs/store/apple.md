---
layout: default
title: Apple Store
parent: Store Configuration
nav_order: 3
---

# Apple Store
{: .no_toc }
`App Store Connect` requires the following images:

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

### Screenshots  
Screenshots must be included in upload for iOS. Screenshots can be generated automatically (for
    both android and ios) using [https://pub.dartlang.org/packages/screenshots](https://pub.dartlang.org/packages/screenshots). Alternatively
    they can be generated manually.

### App Store Icon  
iOS Apps must include a 1024x1024px App Store Icon in PNG format.
    
    See https://makeappicon.com/

    Store in `ios/fastlane/metadata/app_icon.png`
    
### App Store Icon for iPad  
Since flutter supports iPad, a related app icon is required of exactly '167x167' pixels, 
    in .png format for iOS versions supporting iPad Pro (which is all flutter apps).

---
