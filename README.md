# Odoo Provider

Describe how to create a odoo provider to perform database operation (insert,update,delete,etc) on a model.

this package depends on [odoo](https://pub.dev/packages/odoo)

# Usage

1. Create a class which implement IOdooModel

```
class User implements IOdooModel {
  final int? id; //false
  final String? login; //false
  final String? name; //false

  User({this.id, this.login, this.name});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }

  @override
  int? getId() {
    return this.id;
  }

  @override
  String getTableName() => "res.users";

  @override
  Map<String, dynamic> toJsonWithReduce(
      bool Function(MapEntry<String, dynamic> p1) validate) {
    Map<String, dynamic> fields = this.toJson();
    Map<String, dynamic> tmp = {};
    for (final field in fields.entries) {
      if (validate(field) == false) {
        continue;
      }

      tmp.putIfAbsent(field.key, () => field.value);
    }
    return tmp;
  }

  @override
  Map<String, dynamic> toJsonWithoutNullAndId() {
    return toJsonWithReduce((MapEntry entry) {
      if (entry.value == null || entry.key == 'id') {
        return false;
      }
      return true;
    });
  }

  @override
  List<String> getColumns() {
    List<String> resp = [];
    final tmp = this.toJson();
    for (final entry in tmp.keys) {
      resp.add(entry);
    }
    return resp;
  }
}

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      id: json['id'] as int,
      login: json['login'] as String,
      name: json['name'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'name': instance.name
    };

```

too much writing just to implement IOdooModel ? you can use [builder](https://pub.dev/packages/odoo_provider_builder)

2. Assign your class to class OdooProvider

```
final odoo = Odoo(
        Connection(url: Url(Protocol.http, "localhost", 8069), db: 'odoo'));
await odoo.connect(Credential("admin", "admin"));
final userProvider = OdooProvider(adapter: odoo, model: User());
await userProvider.insert(User(login: "test2222", name: "test"));
await userProvider.[DATABASE_OPERATION]
```

# More Examples

Please see \test\odoo_provider_test.dart for more examples.