import 'package:router_management/router_management.dart';

class ProfileValidator with PageValidator {
  const ProfileValidator();

  @override
  Future<bool> call(NavigationPage page, Navigation navigation,
      PageArguments arguments) async {
    if (arguments.query['name'] != null) {
      return true; // If it has the person's name activate the page
    }

    navigation.pushToUnknownPage(); // Push to unknown page

    return false; // Don't activate the page
  }
}
