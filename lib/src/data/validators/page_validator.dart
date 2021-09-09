import '../mixins/navigation.dart';
import '../models/navigation_page.dart';
import '../models/page_arguments.dart';

/// [PageValidator] can be used to validate any pages with
/// [NavigationPage.validators]
mixin PageValidator {
  /// Is used to validate the page when it will be activated by a system call
  Future<bool> call(
    NavigationPage page,
    Navigation navigation,
    PageArguments arguments,
  );
}