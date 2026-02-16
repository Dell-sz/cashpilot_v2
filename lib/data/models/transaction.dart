class Transaction {
  final String id;
  final String userId;
  final String? categoryId;
  final String? categoryName; // Para exibição (join)
  final double amount;
  final String type; // 'income' | 'expense'
  final String description;
  final DateTime date;
  final bool isRecurring;
  final String? recurringFrequency;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    this.categoryId,
    this.categoryName,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
    required this.isRecurring,
    this.recurringFrequency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String?,
      categoryName: json['categories'] != null
          ? (json['categories'] as Map<String, dynamic>)['name'] as String?
          : null,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      description: json['description'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      isRecurring: json['is_recurring'] as bool? ?? false,
      recurringFrequency: json['recurring_frequency'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date.toIso8601String().split('T').first, // Apenas YYYY-MM-DD
      'is_recurring': isRecurring,
      'recurring_frequency': recurringFrequency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Para inserir nova transação
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date.toIso8601String().split('T').first,
      'is_recurring': isRecurring,
      'recurring_frequency': recurringFrequency,
    };
  }

  // Formatar valor como moeda
  String get formattedAmount {
    return 'R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Ícone baseado no tipo
  String get icon {
    if (type == 'income') return '💰';
    return categoryName?.substring(0, 1) ?? '💸';
  }

  Transaction copyWith({
    String? categoryId,
    double? amount,
    String? type,
    String? description,
    DateTime? date,
    bool? isRecurring,
    String? recurringFrequency,
  }) {
    return Transaction(
      id: id,
      userId: userId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      description: description ?? this.description,
      date: date ?? this.date,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
