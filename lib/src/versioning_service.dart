// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import '../versioning_anything.dart';

class VersioningService {
  final List<VersioningBase> _versioning = [];
  final List<String> _versioningExecuteds = [];

  VersioningService add(VersioningBase versioning) {
    _versioning.add(versioning);
    return this;
  }

  Future<void> execute(VersioningServiceProviderBase provider) async {
    for (VersioningBase v in _versioning) {
      if (_versioningExecuteds.contains(v.resourceName)) continue;
      _versioningExecuteds.add(v.resourceName);
      if (!(await v.canExecute())) continue;
      await _execute(v, provider);
    }
  }

  Future<void> _execute(
      VersioningBase v, VersioningServiceProviderBase p) async {
    final m = await p.get(v.resourceName);

    if (m == null)
      await _create(v, p);
    else
      await _update(v, m, p);
  }

  Future<void> _create(
    VersioningBase v,
    VersioningServiceProviderBase p,
  ) async {
    await v.create();
    await p.set(VersioningModel(
      resourceName: v.resourceName,
      version: v.update().length,
    ));
  }

  Future<void> _update(
    VersioningBase v,
    VersioningModel model,
    VersioningServiceProviderBase provider,
  ) async {
    int version = model.version;
    final functions = v.update();

    // Check if exist any update function.
    if (functions.isEmpty) return;

    // Check is is updated.
    if (version >= functions.length) return;

    for (var i = version; i < functions.length; i++) {
      await functions[i]();
      version = i + 1;
    }

    await provider.set(
      VersioningModel(
        resourceName: v.resourceName,
        version: version,
      ),
    );
  }

  void reset() {
    _versioning.clear();
    _versioningExecuteds.clear();
  }

  // Singleton factory.
  static VersioningService? _instance;
  factory VersioningService() => _instance ??= VersioningService._internal();
  VersioningService._internal();
}
