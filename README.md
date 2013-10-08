AOTrayView
==========

A nice tray to show items at the bottom of an iOS screen.  It's best used in combination with a table view that allows for multiple items to be selected.  For example, in this list from the app deci, a user can select their Facebook friends to invite to collaborate on a social decision.  For each person that is selected from the table, their Facebook profile picture is added to the AOTrayView.  The avatar pops in or out with a nice animation.  Once more avatars are added to the tray view than can fit horizontally, the AOTrayView allows for the user to scroll side to side to see them.

<img src="https://github.com/obuseme/AOTrayView/blob/master/Screenshots/pic1.png?raw=true">

Used in the app deci.

## Installation via CocoaPods
Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project, and Create and Edit your Podfile and add RestKit:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
platform :ios, '7.0' 
pod 'AOTrayView', '~> 0.0.1'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```N
