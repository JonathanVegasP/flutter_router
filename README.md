# Router Management
A plugin that wraps the Navigator 2.0 with a syntax sugar for Flutter Developers

## Getting Started
* Installing the package with Flutter CLI:

> $ flutter pub add router_management

* Installing the package manually:

Open the pubspec.yaml file, search for **dependencies:** and write this below:

```
dependencies:
   router_management: ^2.3.2
   ...
```

## Usage
1. Create a **RouterBuilder** that builds a **Router** for example:

```dart
  Widget buildRouter(
     RouteInformationProvider routeInformationProvider,
     RouteInformationParser<Object> routeInformationParser,
     RouterDelegate<Object> routerDelegate) {
   return MaterialApp.router(
     routeInformationProvider: routeInformationProvider,
     routeInformationParser: routeInformationParser,
     routerDelegate: routerDelegate,
     title: 'Router Management Example',
     localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
```

2. Create a **Widget** that represents a page for example:

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Declare the path as constant
  static const path = '/home/:name';

  // Declare the name as constant
  static const name = 'Home';

  @override
  Widget build(BuildContext context) {
    final arguments = context.arguments; // Get the page's arguments

    return Scaffold(
      body: Center(
        child: Text(
          'Welcome ${arguments.params['name']}',
          style: const TextStyle(fontSize: 32, color: Colors.black),
        ),
      ),
    );
  }
}
```

3. Implements the **NavigationRouter** into the **void main()** method for example:

```dart
void main() {
  runApp(NavigationRouter(
    child: buildRouter, // The RouterBuilder that builds a Router
    pages: [
      NavigationPage(
        path: SplashScreen.path,
        builder: () => const SplashScreen(),
        name: SplashScreen.name,
      ),
      NavigationPage(
        path: HomeScreen.path,
        builder: () => const HomeScreen(),
        name: HomeScreen.name,
      ),
    ], // The pages
    initialPage: SplashScreen.path,  // The initial page's path. Defaults to "/"
    unknownPage: NavigationPage(
      path: NotFound.path,
      builder: () => const NotFound(),
      name: NotFound.name,
    ), // A page that is built when an unknown path is passed
  ));
}
```

4. Use the **Navigation** instance from **NavigationService.instance** to controls the Navigator 2.0 with Imperative methods for example:

> NavigatorService.instance.pushReplacement('/home/John Doe');
> or using Router Management extensions on BuildContext
> BuildContext.navigator.pushReplacement('/home/John Doe');

5. To get the path's arguments use the extension on **BuildContext** for example:

```dart
@override
Widget build(BuildContext context) {
  final arguments = context.arguments;
  ...
```

6. Keep coding :)

## APIS
The Router Management has many APIS to ensure that you can handle the Navigator 2.0

#### NavigationRouter
Is the widget core for Navigator 2.0 implementation

* Props

| Name | Description | Required |
| :--: | ----------- | :------: |
| child | Is used to build a **Router** to handle the Navigator 2.0 implementation | true |
| pages | Is used to create pages that can be accessed by the Navigator 2.0 | true |
| initialPage | Is used to render the page that has the same path. If the **PageWidget.build** returns a router without a **RouteInformationProvider** it will not work correctly. Defaults to **"/"** | false |
| navigatorObservers | Is used to observe the Navigator 2.0 when navigating between screens. Defaults to **List.empty()** | false |
| useHash | If it is true then will be used the default url strategy that is a path with hash, for example: flutterexample.dev/#/path/to/screen, else will be flutterexample.dev/path/to/screen. Defaults **to false** | false |
| restorationScopeId | Is used to save and restore the navigator 2.0 state, if it is null then the state will not be saved. Defaults to **null** | false |
| unknownPage | Is used to create an unknown page with the given path. Defaults to **null** | false |
| transitionDuration | Is used to controls the animation transition. Defaults to **Duration(milliseconds: 400)** | false |
| transitionsBuilder | Is used to build a global custom animation transition when navigating to another page. Defaults: **If the platform is web then will not has any transition else will be null** | false |

* Static Methods

| Name | Description |
| ---- | ----------- |
| defaultWebTransition | Is used to get the default web transition that means it does not have any transition when navigating between screens |

#### NavigationPage
Is used to create a page into the **NavigationRouter**

* Props

| Name | Description | Required |
| :--: | ----------- | :------: |
| path | Is the page's path like: /home. To declare a page's param use this pattern "/:param-name" then use the **PageArguments.params['param-name']** to get the data from the path like: /profile/:id | true |
| builder | Is used to build the page and create an active page | true |
| fullscreenDialog | Is used to create a fullscreen dialog page. Defaults to **false** | false |
| maintainState | If it is false the state of the page will be discarded when navigating to another page. Defaults to **true** | false |
| transitionDuration | Is used to controls the animation transition. Defaults to **NavigationRouter.transitionDuration** | false |
| validators | is used to controls the page's activation when it must has more than the basics arguments like an id or something else, if it returns false then the page will be redirect to the initial page or use the **Navigation** to redirect to another page. Defaults to **List.empty()** | false |
| restorationId | is used to save and restore the page's state, if it is **null** then the state will not be saved. Defaults to **null** | false |
| name | Is used to name the page. Defaults to **null** | false |
| transitionsBuilder | Is used to create a custom transition to the page. Defaults to **System's Animation Transition** | false |

#### NavigationService
Is the core class that is used to get the actual **Navigation** instance

* Static Methods

| Name | Description |
| :--: | ----------- |
| instance | Is the implementation of Navigator 2.0 |

#### Navigation
Is the core navigation interface and is used to controls the Navigator 2.0

* Methods

| Name | Description |
| :--: | ----------- |
| push | Is used to navigate to another screen maintaining the previous screen |
| pushReplacement | Is used to navigate to another screen replacing the previous screen |
| pushAndReplaceUntil | Is used to navigate to another screen and replaces the previous screens until the condition returns **true** |
| pop | Is used to navigate back to the previous screen |
| popAndPush | Is used to navigate back to the previous screen and navigate to another screen |
| popUntil | Is used to navigate back until the condition returns **true** |
| pushToUnknownPage | Is used to navigate to the unknown page |

* Getters

| Name | Description |
| :--: | ----------- |
| canPop | Is used to know when the page can be popped |

#### PageArguments
Is used to get the current page's arguments

* Props

| Name | Description |
| :--: | ----------- |
| uri | Is used to get the path's data |
| data | Is used to get the data that can be passed into the **Navigation** push methods |
| params | Is used to get the path's params |
| path | Is a shortcut from **Uri.path** to get the current path |
| paths | Is a shortcut from **Uri.pathSegments** to get the current paths segments |
| completePath | Is a shortcut from **Uri.toString()** to get the current complete path |
| query | Is a shortcut from **Uri.queryParameters** to get the current query as a **Map<String,String>** object |
| queries | Is a shortcut from **Uri.queryParametersAll** to get the current list of queries as a **Map<String,List\<String>>** object

#### PageValidator
Can be used to validate any pages with **NavigationPage.validators**

* Methods

| Name | Description |
| :--: | ----------- |
| call | If it returns false then the page cannot be activated and can be used to redirect to another page when it is needed |

## Extensions

The Router Management has two extensions to maintain a clean code

#### NavigationExtension
Is used to get the current **Navigation** instance on the **BuildContext**

* Getters

| Name | Description |
| :--: | ----------- |
| navigator | Is used to get the current **Navigation** instance |

#### PageArgumentsExtension
Is used to get the current **PageArguments** on the **BuildContext**

* Getters

| Name | Description |
| :--: | ----------- |
| arguments | Is used to get the current **PageArguments** |