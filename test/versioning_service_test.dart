import 'package:versioning_anything/versioning_anything.dart';
import 'package:test/test.dart';

void main() {
  group('VersioningService', () {
    setUp(() {
      VersioningService().reset();
    });

    test('It runs correctly', () async {
      List<VersioningModel> saved = [];
      final provider = VersioningServiceProviderMock(
        (resourceName) async => null,
        (model) async {
          saved.add(model);
        },
      );

      VersioningService().add(VersioningMock());
      await VersioningService().execute(provider);

      assert(
        saved.length == 1 &&
            saved.first.resourceName == VersioningMock().resourceName &&
            saved.first.version == 2,
        true,
      );
    });

    test('Dont executed if canExecute is false', () async {
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
    });
  });
}

class VersioningServiceProviderMock implements VersioningServiceProviderBase {
  final Future<VersioningModel?> Function(String resourceName) _get;
  final Future<void> Function(VersioningModel model) _set;

  VersioningServiceProviderMock(this._get, this._set);

  @override
  Future<VersioningModel?> get(String resourceName) => _get(resourceName);

  @override
  Future<void> set(VersioningModel model) => _set(model);
}

class VersioningMock implements VersioningBase {
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
