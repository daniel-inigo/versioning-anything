import '../versioning_anything.dart';

abstract class VersioningProviderBase {
  Future<VersioningModel?> get(String resourceName);
  Future<void> set(VersioningModel model);
}
