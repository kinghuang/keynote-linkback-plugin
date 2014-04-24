# Keynote LinkBack Plugin

The Keynote LinkBack Plugin added LinkBack support to Keynote versions 2 through 4. It masquerades as an effects plugin in Keynote and uses Objective-C method swizzling to inject custom code to handle LinkBack functions.

## History

LinkBack was [announced by Nisus Software][1] along with The Omni Group and Blacksmith in March 2005. It provides a way for Mac OS X applications to embed objects between LinkBack enabled applications so that shared objects remain editable and dynamically updatable. The concept is similar to [OLE on Windows][2], [Publish and Subscribe on classic Mac OS][3], and [OpenDoc][4]. LinkBack comes with a pre-written framework that makes implementation easy in Mac OS X Cocoa applications.

[1]: http://nisus.com/pr/archive/050304.php
[2]: http://en.wikipedia.org/wiki/Object_Linking_and_Embedding
[3]: http://en.wikipedia.org/wiki/Publish_and_Subscribe_(Mac_OS)
[4]: http://en.wikipedia.org/wiki/OpenDoc

The Keynote LinkBack Plugin takes advantages of the sfxplugin system in Keynote 2 to 4 to add LinkBack support to Apple's presentation software. It was [first announced on the linkbackdev mailing list](http://lists.nisus.com/private.cgi/linkbackdev-nisus.com/2005-March/000015.html) on March 12, 2005. The plugin was last updated around late 2007 for Keynote 4.

## Approach

The plugin is built as a standard Cocoa bundle, configured for loading by Keynote as a sfx, presumeably meaning Slide FX. K2LinkBackSupport is declared as the `NSPrincipalClass` in the bundle's `Info.plist`. Its class initializer uses [Unsanity's Application Enhancer (APE)](http://en.wikipedia.org/wiki/Application_Enhancer) to patch methods in various Keynote classes. Categories are also used to add methods to classes.

Headers for modified classes were derived using [class-dump](http://stevenygard.com/projects/class-dump/).

## License

Copyright 2014 King Chung Huang

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.