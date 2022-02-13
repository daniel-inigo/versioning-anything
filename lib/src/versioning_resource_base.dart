abstract class VersioningResourceBase {
  String get resourceName;
  Future<bool> canExecute();

  /// Sets the latest version of the resource when it did not previously exist.
  /// Fires when a [VersioningModel] is not obtained from [VersioningServiceProvider].
  ///
  /// After executing this function, no [update] function will be executed,
  /// the latest version of the list position returned in [update] will
  /// be assigned as current.
  Future<void> create();

  /// They will be executed when a [VersioningModel] with a version number less
  /// than the length of the returned list is obtained.
  ///
  /// [Important] do not remove items from the list. If you want to kill
  /// a function from execution, leave the function empty.
  List<Future<void> Function()> update();
}
