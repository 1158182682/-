class ChecklistItemModel {
  final String id;
  final String tripId;
  final String category;
  final String title;
  final String? note;
  final int quantity;
  final int isChecked;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;

  const ChecklistItemModel({
    required this.id,
    required this.tripId,
    required this.category,
    required this.title,
    this.note,
    this.quantity = 1,
    this.isChecked = 0,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'trip_id': tripId,
        'category': category,
        'title': title,
        'note': note,
        'quantity': quantity,
        'is_checked': isChecked,
        'sort_order': sortOrder,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory ChecklistItemModel.fromMap(Map<String, dynamic> map) => ChecklistItemModel(
        id: map['id'] as String,
        tripId: map['trip_id'] as String? ?? '',
        category: map['category'] as String? ?? '',
        title: map['title'] as String? ?? '',
        note: map['note'] as String?,
        quantity: map['quantity'] as int? ?? 1,
        isChecked: map['is_checked'] as int? ?? 0,
        sortOrder: map['sort_order'] as int? ?? 0,
        createdAt: map['created_at'] as String? ?? '',
        updatedAt: map['updated_at'] as String? ?? '',
      );
}
