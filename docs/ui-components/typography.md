---
layout: default
title: Flutter
parent: App Configuration
nav_order: 1
---

# Flutter
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## App Name and App ID
The App Name and App ID are identifiers used by both stores. Separate identifiers can be used in each store. 

To make things simple, it is recommended to use the same identifiers in both stores.
 
These identifiers will be used in several places to configure the app for release.
 
1. Pick an App Name  
The app name, which is what the user sees, should be unique in both stores. Let's say your app name is `MyUniqueAppName`.

1. Pick an App ID  
Decide on an Application ID for your app that is unique in both stores. For example, `com.mycompany.todo`.

1. _Optional_: Version tracking  
The build number and release tag change with each build and release of the app. It is useful to be able to embed these values in the build artifact. This allows tracing-back from any version of the app, running on any device, to the build and source code.  
To enable build and release tracking comment-out the version in your pubspec.yaml:
```yaml
# version: 1.0.0+1
```

#### On ios:
1. Open Xcode. For example:

       open ios/Runner.xcworkspace
    
1. Update the `Display Name` to `MyUniqueAppName`.
1. Update the `Bundle Identifier` to the same as the application id used on android, eg, `com.mycompany.todo`.

    Note: `Version` and `Build` can be ignored. These are updated automatically by the CICD.
1. In `Runner>Runner>Info.plist`, set `Bundle display name` to `MyUniqueAppName`.
1. Disable automatic signing
1. In `Signing (Release)` select the provisioning profile created during match setup.
    For example, use the following provisioning profile:
        
        match AppStore com.mycompany.todo
        
    Note: if match is not already set-up you will have to return to this step after match is set-up.
1. (Recommended) Icons  
Upload will fail if required icons are missing from the Asset Catalog. To generate a complete set
    of icons from a single image, see https://makeappicon.com. This will generate a complete Asset
    Catalog. Overwrite the existing catalog using:

        cp <location of downloaded icons>/ios/AppIcon.appiconset/* ios/Runner/Assets.xcassets/AppIcon.appiconset










By default, Fledge uses a native system font stack for sans-serif fonts:

```scss
-apple-system, BlinkMacSystemFont, "helvetica neue", helvetica, roboto, noto, "segoe ui", arial, sans-serif
```

ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
{: .fs-5 .ls-10 .code-example }

For monospace type, like code snippets or the `<pre>` element, Fledge uses a native system font stack for monospace fonts:

```scss
"SFMono-Regular", Menlo, Consolas, Monospace
```

ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
{: .fs-5 .ls-10 .text-mono .code-example }

---

## Responsive type scale

Fledge uses a responsive type scale that shifts depending on the viewport size.

| Selector              | Small screen size `font-size`    | Large screen size `font-size` |
|:----------------------|:---------------------------------|:------------------------------|
| `h1`, `.text-alpha`   | 32px                             | 36px                          |
| `h2`, `.text-beta`    | 18px                             | 24px                          |
| `h3`, `.text-gamma`   | 16px                             | 18px                          |
| `h4`, `.text-delta`   | 14px                             | 16px                          |
| `h5`, `.text-epsilon` | 16px                             | 18px                          |
| `h6`, `.text-zeta`    | 18px                             | 24px                          |
| `body`                | 14px                             | 16px                          |

---

## Headings

Headings are rendered like this:

<div class="code-example">
<h1>Heading 1</h1>
<h2>Heading 2</h2>
<h3>Heading 3</h3>
<h4>Heading 4</h4>
<h5>Heading 5</h5>
<h6>Heading 6</h6>
</div>
```markdown
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6
```

---

## Body text

Default body text is rendered like this:

<div class="code-example" markdown="1">
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
</div>
```markdown
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
```

---

## Inline elements

<div class="code-example" markdown="1">
Text can be **bold**, _italic_, or ~~strikethrough~~.

[Link to another page](another-page).
</div>
```markdown
Text can be **bold**, _italic_, or ~~strikethrough~~.

[Link to another page](another-page).
```

---

## Typographic Stores Configuration

There are a number of specific typographic CSS classes that allow you to override default styling for font size, font weight, line height, and capitalization.

[View typography utilities]({{ site.baseurl }}{% link docs/utilities/utilities.md %}#typography){: .btn .btn-outline }
