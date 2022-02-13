# Versioning Anything
Simple library for version manager of tables, databases or anything.

## Examples

### Implement interface VersioningBase in a class.

```dart
    class VersioningTableExample implements VersioningBase {
        @override
        String get resourceName => "table_example";

        @override
        Future<bool> canExecute() async => true;


        // This will run when the provider turn a null VersionModel.
        @override
        Future<void> create() async {
            print("Created");
        }


        // This will run when provider returned a exists VersionModel.
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
```

### Create a VersionModel provider implments VersionServiceProviderBase.

```dart
    class VersioningServiceProviderExample implements VersioningServiceProviderBase {
        @override
        Future<VersioningModel?> get(String resourceName) async {
            // Read your current database library for retrieve the  model.
            return null;
        };

        @override
        Future<void> set(VersioningModel model) async {
            // Save the model in your current database library.
        }
    }   
```

### Add the versioning resources, the provider and execute the service.
```dart
    await VersioningService()
        .add(VersioningTableExample())
        .add(VersioningTableExample2())
        .execute(VersioningServiceProviderExample());
```

### When one resource is executed, it don't will executed anymore. In this case you can reset the service.
```dart
    await VersioningService().reset();
```

## License
This library is licensed under MIT.
