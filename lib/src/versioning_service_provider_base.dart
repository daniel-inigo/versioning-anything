import '../versioning_anything.dart';

abstract class VersioningServiceProviderBase {
  Future<VersioningModel?> get(String resourceName);
  Future<void> set(VersioningModel model);
}
