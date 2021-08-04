class ColumnDefinition {
  final String fieldName;
  final Type type;
  final bool required;

  const ColumnDefinition(
      {required this.fieldName, required this.type, this.required = false});
}

class OdooModel {
  final String tableName;
  final String className;
  final List<ColumnDefinition> columns;
  final String idFieldName;
  const OdooModel(
      {required this.className,
      required this.tableName,
      required this.columns,
      this.idFieldName = "id"});
}
