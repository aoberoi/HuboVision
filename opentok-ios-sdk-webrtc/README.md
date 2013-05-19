OpenTok WebRTC on iOS SDK
=========================

This SDK lets you use OpenTok on WebRTC video sessions in apps you build for iPad, iPhone, and iPod touch devices.

To get started, [sign up for a Developer Account](https://dashboard.tokbox.com/signups/new) and get your API Key.

You can use OpenTok video sessions across iOS devices AND web clients that use OpenTok on
WebRTC. For details about using this SDK with web clients, see the
[JavaScript documentation](http://www.tokbox.com/opentok/webrtc/docs/js/reference/index.html) at the TokBox website.

Using the OpenTok on WebRTC iOS SDK
-----------------------------------

See the [reference documentation for the OpenTok iOS SDK](http://www.tokbox.com/opentok/ios/docs/index.html).

There are two important differences to keep in mind when working with the OpenTok on WebRTC iOS SDK (compared with
the [non-WebRTC version](https://github.com/opentok/opentok-ios-sdk) of the OpenTok iOS SDK):

*  You must use a [peer-to-peer streaming](http://www.tokbox.com/opentok/docs/concepts/peer_to_peer.html)
   enabled OpenTok Session. You can enable p2p when creating a session using the Project Tools on your
   [Developer Dashboard](https://dashboard.tokbox.com/projects) or enable it for any Session created with
   our supported [server-side libraries](http://www.tokbox.com/opentok/docs/concepts/server_side_libraries.html).

   Peer-to-peer streaming helps reduce latency by letting the media stream skip a hop to an external server,
   resulting in better performance. A few limitations introduced by this technique are discussed below.

*  At this time you cannot run your application in the iOS Simulator. Just run it on your device for testing. We will
   be addressing this in a future release.

Supported devices
-----------------

The OpenTok on WebRTC iOS SDK is supported on the following devices:

* iPhone 4S / 5
* iPad 2 / 3 / 4 / mini

The OpenTok on WebRTC iOS SDK is supported on wifi connections.

Release notes
-------------

May 16, 2013 - Version 2.1.2

* Support for Mantis, the OpenTok media server for WebRTC.
* Fixed some issues that were occuring when the OpenTok library ran in the background.
* Added native support for armv7s architecture.
* Fixed a bug that causes inconsistent UI when manipulating media track functions (eg. publishVideo, subscribeToAudio, etc.)

April 24, 2013

*  OpenTok on WebRTC now provides increased connectivity. WebRTC is a peer-to-peer protocol that does not work on some
restricted networks. Many environments, especially cellular and corporate networks, have strict network policies that
prevent WebRTC apps from working. OpenTok on WebRTC now overcomes these restrictions to connect clients, even in
environments that have NAT-style firewalls. However, an app cannot use WebRTC if UDP is completely blocked on the
network.

April 9, 2013

* This is version 2.1.1 of the OpenTok iOS SDK.
* We have corrected the name of the `[OTPublisherDelegate publisher:didChangeCameraPosition:]` message. (See the notes for
April 5, 2013.)

April 5, 2013

* This is version 2.1 of the OpenTok on WebRTC iOS SDK.
* You can now specify the camera a publisher uses by setting the `[OTPublisher cameraPosition]` property. The OTPublisherDelegate sends
the `[OTPublisherDelegate publisherDidChange:cameraPosition:]` message in response to a camera change.
* Publishers and subscribers now continue to publish and subscribe to streams when running in the background.
* This release improves connectivity between WebRTC clients.
* This release includes bug fixes to improve performance and stability.


Known issues
------------

* Some features available in the OpenTok SDK for other platforms (such as JavaScript) are not supported in the OpenTok iOS SDK. These unsupported features include peer-to-peer streaming and archiving.

* The `[OTSubscriber subscribeToAudio]` and `[OTSubscriber subscribeToVideo]` messages are currently unsupported.

* The OpenTok iOS SDK supports iOS 5 and later only.

* Our graphics rendering pipeline causes this error to be logged when debugging: "CGContextDrawImage: invalid context 0x0." This should not affect the performance of your app. If you experience video quality issues, please let us know.

* You cannot target the iOS Simulator. Build and deploy to a supported iOS device.

* iOS 6.1.3 seems to have some issues when the OpenTok on WebRTC library is running in the background. We are investigating this.

In XCode, you need to remove armv7s from the Valid Architectures section of the Build Settings for your project.

Peer-to-peer Streaming Limitations
----------------------------------

If you use a session that does not support peer-to-peer streaming, calling `[OTSession connectWithApiKey:token:]`
results in the `[OTSessionDelegate session:didFailWithError:]` message. The error message is defined by the
`OTP2PSessionRequired` enum in the OTError.h file.

If a session already has two connected clients, calling `[OTSession connectWithApiKey:token:]`
results in the `[OTSessionDelegate session:didFailWithError:]` message. The error message is defined by the
`OTP2PSessionMaxParticipants` enum in the OTError.h file.

You cannot subscribe to a stream published by your own app. If you call `[OTSubscriber initWithStream:delegate:]`
passing in a stream you publish, the OTSubscriberDelegate sends the `[OTSubscriberDelegate subscriber:didFailWithError:]`
message. The error message is defined by the `OTSelfSubscribeFailure` enum in the OTError.h file.

Developer and client requirements
---------------------------------

* The OpenTok iOS SDK requires XCode 4.2 or later. XCode 4.2 requires Mac OS 10.6.8 or later.

* You need to test OpenTok apps on an iOS device running iOS 5. The OpenTok iOS SDK supports iPhone 3GS
(subscribing only), iPhone 4 and higher, iPod touch 4th generation and higher, and all iPad versions. 

* To test OpenTok apps on an iOS device, you will need to register as an Apple iOS developer at
[http://developer.apple.com/programs/register/](http://developer.apple.com/programs/register/).

Setting up your development environment
---------------------------------------

Download the webrtc branch of the [OpenTokHelloWorld sample app](https://github.com/opentok/OpenTok-iOS-Hello-World/tree/webrtc) and the
[OpenTok iOS SDK](https://github.com/opentok/opentok-iOS-sdk). Use `git clone --recursive -b webrtc https://github.com/opentok/OpenTok-iOS-Hello-World.git`.

The OpenTokHelloWorld app publishes to a demo session, and subscribes to its own stream
(or any other stream in the session). Included in the OpenTok on WebRTC iOS SDK are files you will need to develop
your own apps:

* **Opentok.framework** -- Add this framework to your project. Note that to use the library you must also 
include the opentok.bundle file and the headers included in in the Frameworks directory of the OpenTokHelloWorld
sample app.

* **opentok.bundle** -- Add the opentok.bundle file to your project. The opentok.bundle file is located
in the Opentok.framework/Versions/A/Resources subdirectory of the OpenTok iOS SDK. 

* **Frameworks directory** -- The OpenTok iOS library uses linked frameworks and dynamic libraries provided by iOS.
We cannot pre-link them in the OpenTok framework, so your project must link them. Expand the "Frameworks" directory
of the sample application in XCode project browser. Drag and drop the contents of this directory into your own iOS project.

You can connect to the same OpenTok session that the OpenTokHello sample app uses by going to http://www.tokbox.com/opentok/webrtc/docs/js/tutorials/helloworld.html. You can generate a new session ID at this URL:

https://dashboard.tokbox.com/projects

Be sure to create a peer-to-peer session.

You can also create a web page that connects to the same session as the app.

Using the sample apps
---------------------

* The webrtc branch of the [OpenTokHello](https://github.com/opentok/OpenTok-iOS-Hello-World/tree/webrtc) sample app shows
the most basic functionality of the OpenTok iOS SDK: connecting to sessions, publishing streams, and subscribing to streams.

     Use `git clone --recursive -b webrtc https://github.com/opentok/OpenTok-iOS-Hello-World.git` to obtain the webrtc branch of the
     OpenTokHello Sample App project.

* The [OpenTokBasic](https://github.com/opentok/opentok-iOS-Basic-Tutorial) sample app uses more of the OpenTok iOS SDK than the OpenTokHello sample app does.

Creating your own app using the OpenTok iOS SDK
-----------------------------------------------

Here are the basic steps in creating your own app:

1. In XCode, create a new project. The simplest application is a Single-View application.

2. Open the project navigator in Xcode.

3. Drag the Opentok.framework directory from the Mac OS Finder to the Frameworks directory for for your project in XCode.

4. Drag the opentok.bundle file from the Mac OS Finder to root directory for your project in XCode.

	The opentok.bundle file is located in the Opentok.framework/Versions/A/Resources subdirectory of the OpenTok iOS SDK.


5. The OpenTok framework requires a few other frameworks and libraries to be added to your project. The easiest way to add them is
to copy them from the OpenTokHello sample app.

	Open the OpenTokHello sample app in XCode. Drag all of the additional frameworks from the frameworks folder (in the project navigator)
	of the OpenTokHello project into the frameworks folder of your project.
	
	The additional frameworks and libraries include the following: AudioToolbox.framework, AVFoundation.framework, CFNetwork.framework,
	CoreAudio.framework, CoreMedia.framework, CoreTelephony.framework, CoreVideo.framework, libz.dylib, libstdc++.dylib, MobileCoreServices.framework,
	OpenGLES.framework, QuartzCore.framework, Security.framework, SystemConfiguration.framework.
	
6. Remove armv7s from the Valid Architectures section of the Build Settings for your project.

Next steps:

1. In the ViewController.h file, add the following line (after `import <UIKit/UIKit.h>`):

		#import <Opentok/Opentok.h>

2. Assuming that your ViewController will implement the OTSessionDelegate, OTPublisherDelegate, and OTSubscriberDelegate protocols,
edit the `@interface` declaration in the ViewController.h file to the following:

		@interface ViewController : UIViewController <OTSessionDelegate, OTSubscriberDelegate, OTPublisherDelegate>

3. You will need to implement the required method in each protocol that you add (OTSessionDelegate, OTSubscriberDelegate, OTPublisherDelegate).

4. Add code to initialize and connect to an OpenTok session. And add code to publish and subscribe to streams.
See the code in the OpenTokHello application.

Connect with TokBox and with other OpenTok developers
-----------------------------------------------------

Your comments and questions are welcome. Come join the conversation at the [OpenTok iOS SDK forum](http://www.tokbox.com/forums/ios).
