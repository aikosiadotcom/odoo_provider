class DbColumn {
  final String name;
  final Type type;
  final bool required;

  const DbColumn(
      {required this.name, required this.type, this.required = false});
}

class OdooModel {
  final String tableName;

  final String className;

  final List<DbColumn> columns;

  ///which column is id
  final String id;

  const OdooModel(
      {required this.className,
      required this.tableName,
      required this.columns,
      this.id = "id"});
}
