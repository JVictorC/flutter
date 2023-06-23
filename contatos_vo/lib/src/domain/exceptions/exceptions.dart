abstract class ContactErrosBase implements Exception {
  final String? message;

  ContactErrosBase(this.message);
}

class HomePageListError implements ContactErrosBase {
  @override
  final String? message;

  HomePageListError(this.message);
}
