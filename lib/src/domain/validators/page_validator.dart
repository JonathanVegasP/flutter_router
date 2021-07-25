import '../models/navigation_page.dart';
import '../models/page_arguments.dart';
import '../services/navigation.dart';

/// [PageValidator] can be used to validate any pages with
/// [NavigationPage.validators]
mixin PageValidator {
  Future<bool> call(
    NavigationPage page,
    Navigation navigation,
    PageArguments arguments,
  );
}
