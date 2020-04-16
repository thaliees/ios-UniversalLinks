# Universal Links
[Project created with Xcode V11.4]
[Deployment Target > 11.0 ]

## Project Base.
## Documentation
* [App Search API Validation Tool](https://search.developer.apple.com/appsearch-validation-tool/)
* [Handling Universal Links](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/handling_universal_links)

## Prerequisites
### Apple developer Account
*Note: You must a paid apple developer account. A free account won't work.
1. In your account, create a new Identifier. Is important you select Associated Domains in the Capabilities section.
1. In the BundleID, writes the Bundle Identifier your project of Xcode (example: com.Thaliees.UniversalLinks)

* If you have differents Identifier for each app, you should to create a new Profile.

### App-app-site-association file
Create the file called apple-app-site-association and add the following content:
`{
  "applinks": {
    "apps": [],
    "details": [
    {
      "appID": "TEAM_ID_HERE.BUNDLE_ID_HERE",
      "paths": ["*"]
    }
    ]
  }
}`

Where TEAM_ID_HERE is the team ID that Apple assigned you when you created your Apple developer account. You can find it in the [Apple developer center](https://developer.apple.com/membercenter) and BUNDLE_ID_HERE is the app's bundle ID. In "paths", you can limit the paths value to specific folders or file names, the * means you have access to all routes.

* This file MUST NOT HAVE EXTENSION!
Now that the file is complete, you upload it to the web server.

### Configuring the App
1. Select the "UniversalLinks" project (Navigator menu)
1. Select the "UniversalLinks" target
1. In Signing Section, select a Development Team to User for Provisioning
1. Clic in the Capability and Select Associated Domains
1. Next, press + and add your domain: applinks:YOUR DOMAIN HERE (example: applinks:universalelinks.herokuapp.com/)

### Handle Universal Links
The code you need to handle the link (when it's called) is written in AppDelegate.swift file.