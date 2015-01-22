# QuickCAML
QuickCAML is a tool for quickly authoring and testing CAML queries in SharePoint 2013 and SharePoint Online (Office 365). It's a client-side tool and is designed to be run right in your browser which avoids a lot of governance issues, risk, and red tape. This is a *code-oriented* tool and is geared toward helping you write and test CAML queries quickly (and helping you learn the CAML language if you don't already know it).

And as a code-oriented tool, a key feature is the **intellisense** support! This tool provides context-sensitive suggestions for tag names, attribute names, and attribute values (including list field names where appropriate!).

## Installation Instructions
Right now, QuickCAML is installed by uploading a site page (ASPX file) into a SharePoint wiki page library. The most common scenario is to upload the site page into the **Site Pages** library, but any document library that supports site pages (wiki pages) is fine.

To download the ASPX file, grab it from our latest release: https://github.com/inclinetechnical/QuickCAML/releases/tag/v0.5-beta

Because we use client-side APIs, the tool is scoped to the site collection level or below. Our recommendation is to install the tool in the top-level site of the site collection and change the Site URL to any site within the site collection as needed. However, if your permissions don't allow you to install it in the top-level site, it can be installed within a subsite and used there as well.

If you install the tool in a production environment, you may also want to lock down permissions on it (i.e. customize permissions on the QuickCAML page or the folder it lives in). It depends on your user base and your specific requirements.

## Required Permissions
We're still doing testing to determine exactly what permissions are required to use this tool. So far, it looks like you need at least the "Manage Lists" permission in whatever site you're working with.

## Feedback and Feature Requests
This is a *brand new* tool, and we want to hear from you!! If you have issues with certain browsers, list fields, permissions, or anything else, please use the [Issues](https://github.com/inclinetechnical/QuickCAML/issues) page in this repository to let us know! You can also use the Issues page to request new features.

## SharePoint Version Compatibility
QuickCAML targets SharePoint 2013 (on-premise and Office 365). It is not supported on versions of SharePoint prior to 2013.
