abstract class IShareAdapter {
  Future<void> share(String title);
  Future<void> shareFiles(List<String> directoryFile, String? title);
}
