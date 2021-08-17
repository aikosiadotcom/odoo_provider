import 'package:yao_odoo_service/yao_odoo_service.dart';

abstract class IOdooModel<T> {
  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
  int? getId();
  String getTableName();
  Map<String, dynamic> toJsonWithReduce(
      bool Function(MapEntry<String, dynamic>) validate);
  Map<String, dynamic> toJsonWithoutNullAndId();
  List<String> getColumns();
}

class OdooProvider<T extends IOdooModel, C extends IDatabaseOperation> {
  final C adapter;
  final T model;
  OdooProvider({required this.adapter, required this.model});

  Future<int> insert(T instanceOfModel) async {
    return await adapter.insert(
        model.getTableName(), instanceOfModel.toJsonWithoutNullAndId());
  }

  Future<T?> read(int id) async {
    Map<String, dynamic>? tmp =
        await adapter.read(model.getTableName(), id, this.model.getColumns());
    if (tmp == null) {
      return null;
    }

    return model.fromJson(tmp);
  }

  Future<bool> update(T instanceOfModel) async {
    return await adapter.update(model.getTableName(), instanceOfModel.getId()!,
        instanceOfModel.toJsonWithoutNullAndId());
  }

  Future<bool> delete(int id) async {
    return await adapter.delete(model.getTableName(), id);
  }

  Future<List<T>> query(
      {List<dynamic> where = const [],
      String orderBy = "",
      int offset = 0,
      bool count = false,
      int limit = 50}) async {
    final tmp = await adapter.query(
        from: model.getTableName(),
        select: model.getColumns(),
        where: where,
        orderBy: orderBy,
        offset: offset,
        count: count,
        limit: limit);
    return tmp.map((e) => model.fromJson(e) as T).toList();
  }
}
