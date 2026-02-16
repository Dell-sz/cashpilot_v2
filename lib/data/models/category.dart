class Category {
  final String id;
  final String userId;
  final String name;
  final String color;
  final String icon;
  final String type; // 'income', 'expense', 'both'
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
    required this.icon,
    required this.type,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String,
      type: json['type'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'color': color,
      'icon': icon,
      'type': type,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Para inserir nova categoria (sem id e timestamps)
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'name': name,
      'color': color,
      'icon': icon,
      'type': type,
      'is_default': isDefault,
    };
  }

  Category copyWith({String? name, String? color, String? icon, String? type}) {
    return Category(
      id: id,
      userId: userId,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
