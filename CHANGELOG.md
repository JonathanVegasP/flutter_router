## [2.2.4] - Improved Performance
* Improved Performance on getting the given page

## [2.2.3] - Fix
* Fixed NavigationObserver

## [2.2.2] - Break Change: Removed PageWidget
* Break Change: The PageWidget does not exist, use builder instead

## [2.2.1] - Removed unnecessary Hero controller
* Removed unnecessary Hero Controller. Use the navigatorObservers to add a custom hero controller

## [2.2.0] - Added RouteInformationProvider
* Added the RouteInformationProvider to improve performance when using initial route

## [2.1.1] - Bug Fixes
* A bug was fixed when trying to navigate to another screen

## [2.1.0] - Linking pages when using deep links
* Performance improvements
* Added a way to linking pages with the path provided in the navigation

## [2.0.0] - Navigator 2.0
* Break Changes: The plugin was refactored in favor of Navigator 2.0 from imperative to declarative
* Support for Flutter Web and Deep Links

## [1.3.3] - Improvements
* Optimized the duration of custom animation to run smoothly

## [1.3.2] - Improvements
* Optimized Fade animation

## [1.3.1] - Added DartDoc Comment

## [1.3.0] - Breaking Changes and Bug Fixes
* Optimized the custom transition
* Added semantics to routes
* Fixed fullscreenDialog with useNativeTransitions false

## [1.2.2] - Added shadow to custom transition
* Optimized the custom transition with a shadow during the transition between screens

## [1.1.1] - Breaking Changes and Bug Fixes
* Optimized the custom transition and created compatibility with newer Flutter Versions
* Now to add a route you need to change from Router.define to Router.addRoute
* Changed property nativeTransition to useNativeTransitions
* The plugins does not support initial route anymore for compatibility with newer versions and web
* Fixed a bug that arguments was null
* Fixed a bug on some versions of flutter that was not generating new routes

## [1.0.0] - Initial Release.
