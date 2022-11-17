class TypeModel {
  final int id;
  final String name;

  TypeModel({
    required this.id,
    required this.name,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
      );
}
