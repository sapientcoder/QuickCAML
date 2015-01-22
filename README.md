# QuickCAML
QuickCAML is a tool for quickly authoring and testing CAML queries in SharePoint 2013 and SharePoint Online (Office 365). It's a client-side tool and is designed to be run right in your browser which avoids a lot of governance issues, risk, and red tape. This is a *code-oriented* tool and is geared toward helping you write and test CAML queries quickly (and helping you learn the CAML language if you don't already know it).

And as a code-oriented tool, a key feature is the **intellisense** support! This tool provides context-sensitive suggestions for tag names, attribute names, and attribute values (including list field names where appropriate!).

![alt tag](https://doseofdotnet.files.wordpress.com/2015/01/caml_tool1.png "Screenshot of QuickCAML showing intellisense")

## Installation Instructions
For now, QuickCAML is installed by uploading a site page (ASPX file) into a SharePoint wiki page library. The most common scenario is to upload the site page into the **Site Pages** library, but any document library that supports site pages (wiki pages) is fine.

You can download the ASPX file from our latest release:
https://github.com/inclinetechnical/QuickCAML/releases/tag/v0.5-beta.1

Because we use client-side APIs, the tool is scoped to the site collection level or below. Our recommendation is to install the tool in the top-level site of the site collection and change the Site URL to any site within the site collection as needed. However, if your permissions don't allow you to install it in the top-level site, it can be installed within a subsite and used there as well.

If you install the tool in a production environment, you may also want to lock down permissions on it (i.e. customize permissions on the QuickCAML page or the folder it lives in). It depends on your user base and your specific requirements.

## Required Permissions
We're still doing testing to determine exactly what permissions are required to use this tool. So far, it looks like you need at least the "Manage Lists" permission in whatever site you're working with.

## Feedback and Feature Requests
This is a *brand new* tool, and we want to hear from you!! If you have issues with certain browsers, list fields, permissions, or anything else, please use the [Issues](https://github.com/inclinetechnical/QuickCAML/issues) page in this repository to let us know! You can also use the Issues page to request new features.

For example, does uploading an ASPX file work well for you as a deployment option? Or do you need us to provide another way to install this tool in an environment where you're working? Let us know!

Also, does our approach of loading JavaScript libraries like jQuery and Knockout JS from a CDN (publicly hosted URL) work in your environment, or do you need a version that lets you locally host those files? That's also something we want to know.

## SharePoint & Browser Compatibility
QuickCAML targets SharePoint 2013 (on-premise and Office 365). It is not supported on versions of SharePoint prior to 2013.

QuickCAML should work with IE 9+ as well as modern versions of FireFox, Chrome, and Safari. We're still doing testing to compile the official browser compability list, and we welcome your help with that task!

## A Look at the Future

This list could change or be re-prioritized based on user feedback, but here are some updates and enhancements we're thinking of making:

* Move JavaScript code into its own file on GitHub and use a build process to minify it and merge it with ASPX markup to create the QuickCAML.aspx page for download. This will improve performance and let us re-use the JS code elsewhere as needed (for example, in a server-side version of this tool deployed as a web part or application page).
* Improve the display of query results. Right now we just use a basic HTML table with forward-only paging since that's the only direction natively supported by the client-side APIs. We plan to also offer a text-based, delimited view of results (similar to CSV) and add backward paging. The delimited view definitely presents some challenges since SharePoint embeds commas and newlines in several hidden fields that may be returned with results.
* Add a little more functionality to the JSOM API to mimic what the web services and server-based object model can do. For example, the JSOM API doesn't support the *IncludeMandatoryColumns* option, but that option would be fairly easy for us to duplicate client-side and support it indirectly.
