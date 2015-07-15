# QuickCAML
QuickCAML is a tool for quickly authoring and testing CAML queries in SharePoint 2010 and 2013 (including SPO / Office 365). It's a client-side tool and is designed to be run right in your browser which avoids a lot of governance issues, risk, and red tape. This is a *code-oriented* tool and is geared toward helping you write and test CAML queries quickly (and helping you learn the CAML language if you don't already know it).

And as a code-oriented tool, a key feature is the **intellisense** support! This tool provides context-sensitive suggestions for tag names, attribute names, and attribute values (including list field names where appropriate!).

![alt tag](https://doseofdotnet.files.wordpress.com/2015/01/caml_tool1.png "Screenshot of QuickCAML showing intellisense")

Query settings and options are [documented in the wiki](https://github.com/inclinetechnical/QuickCAML/wiki/Query-Settings-&-Options) for this project.

## Installation Instructions
For now, QuickCAML is installed by uploading a site page (ASPX file) into a SharePoint wiki page library. The most common scenario is to upload the site page into the **Site Pages** library, but any document library that supports site pages (wiki pages) is fine.

You can download QuickCAML for your version of SharePoint from our latest release:
https://github.com/inclinetechnical/QuickCAML/releases/tag/v0.5-beta.3

Because we use client-side APIs, the tool is scoped to the site collection level or below. Our recommendation is to install the tool in the top-level site of the site collection and change the Site URL to any site within the site collection as needed. However, if your permissions don't allow you to install it in the top-level site, it can be installed within a subsite and used there as well.

If you install the tool in a production environment, you may also want to lock down permissions on it (i.e. customize permissions on the QuickCAML page or the folder it lives in). It depends on your user base and your specific requirements.

## Required Permissions
We're still doing testing to determine exactly what permissions are required to use this tool. So far, it looks like you need at least the "Manage Lists" permission in whatever site you're working with.

## Feedback and Feature Requests
This is a *brand new* tool, and we want to hear from you!! If something doesn't work in your browser/environment or there's something you'd like to see, please let us know! You can use the "Issues" page of this repository to submit bugs, issues, questions, or feature suggestions. You do have to be signed into GitHub to submit issues, but creating an account with them is easy and free.

## SharePoint & Browser Compatibility
QuickCAML supports SharePoint 2010 and 2013 (including Office 365).

QuickCAML should work with IE 9+ as well as modern versions of FireFox, Chrome, and Safari. If that's not the case, please log an issue and let us know!

## A Look at the Future

This list could change or be re-prioritized based on user feedback, but here are some updates and enhancements we're thinking of making:

* Create a non-browser version of QuickCAML that could be run locally on a desktop, laptop, or tablet - similar to how other CAML tools like U2U and CamlDesigner work. This would allow for a more powerful app experience while retaining the clean, code-oriented UI and intellisense that are both signatures of QuickCAML.
* Minify JavaScript code in QuickCAML.aspx to maximize performance (could still view non-minified code here on GitHub).
* Clean up display of query results and offer a CSV/delimited option which could be copied-and-pasted from the browser to another tool (like Excel).
* Add a little more functionality to the JSOM API to mimic what the web services and server-based object model can do. For example, the JSOM API doesn't support the *IncludeMandatoryColumns* option, but that option would be fairly easy for us to duplicate client-side and support it indirectly. 
