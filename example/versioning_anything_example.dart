import 'package:versioning_anything/versioning_anything.dart';

void main() async {
  List<VersioningModel> saved = [];
  final provider = VersioningServiceProviderMock(
    (resourceName) async => null,
    (model) async {
      saved.add(model);
    },
  );

  final v = VersioningMock();
  final v2 = VersioningMock();
  v2.name = "Test2";
  v2.canExecuteValue = false;

  await VersioningService().add(v).add(v2).execute(provider);

  assert(
    saved.length == 1 &&
        saved.first.resourceName == v.name &&
        saved.first.version == 2,
    true,
  );

  v2.canExecuteValue = true;
  await VersioningService().execute(provider);
  assert(
    saved.length == 2 &&
        saved.last.resourceName == v2.name &&
        saved.last.version == 2,
    true,
  );
}

class VersioningServiceProviderMock implements VersioningProviderBase {
  final Future<VersioningModel?> Function(String resourceName) _get;
  final Future<void> Function(VersioningModel model) _set;

  VersioningServiceProviderMock(this._get, this._set);

  @override
  Future<VersioningModel?> get(String resourceName) => _get(resourceName);

  @override
  Future<void> set(VersioningModel model) => _set(model);
}

class VersioningMock implements VersioningResourceBase {
  bool canExecuteValue = true;
  String name = "Test";

  @override
  String get resourceName => name;

  @override
  Future<bool> canExecute() async => canExecuteValue;

  @override
  Future<void> create() async {
    print("Created");
  }

  @override
  List<Future<void> Function()> update() => [
        () async {
          print("Update 1");
        },
        () async {
          print("Update 2");
        }
      ];
}
