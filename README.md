<img src="https://s3-us-west-1.amazonaws.com/udacity-content/degrees/catalog-images/nd003.png" alt="iOS Developer Nanodegree logo" height="70" >

# iOS Networking

![Platform iOS](https://img.shields.io/badge/nanodegree-iOS-blue.svg)

This repository contains resources for Udacity's iOS Networking with Swift course.

## Overview

The iOS Networking course teaches students how to use Apple's networking APIs for iOS. The course includes three example applications:

- ImageRequest
- FlickFinder
- TheMovieManager

Each application has an initial and complete version that is fully implemented. For FlickFinder and TheMovieManager, special setup instructions are provided below:

## FlickFinder

Create a `Secrets.plist` file in the same directory as the project's `Info.plist` file. Substitute a Flickr API key where you see "API-KEY-HERE":

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>FlickrAPIKey</key>
	<string>API-KEY-HERE</string>
</dict>
</plist>
```

## TheMovieManager

Create a `Secrets.plist` file in the same directory as the project's `Info.plist` file. Substitute a MovieDB API key where you see "API-KEY-HERE":

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>TheMovieDBAPIKey</key>
	<string>API-KEY-HERE</string>
</dict>
</plist>
```

## Maintainers

@jarrodparkes
