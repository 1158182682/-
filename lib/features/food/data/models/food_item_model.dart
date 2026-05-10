class FoodItemModel {
  final String id;
  final String tripId;
  final String name;
  final String? area;
  final String? address;
  final String? recommendedDish;
  final double? budget;
  final double? actualCost;
  final String? note;
  final String? status;
  final int? rating;
  final String createdAt;
  final String updatedAt;

  const FoodItemModel({
    required this.id,
    required this.tripId,
    required this.name,
    this.area,
    this.address,
    this.recommendedDish,
    this.budget,
    this.actualCost,
    this.note,
    this.status,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'trip_id': tripId,
        'name': name,
        'area': area,
        'address': address,
        'recommended_dish': recommendedDish,
        'budget': budget,
        'actual_cost': actualCost,
        'note': note,
        'status': status,
        'rating': rating,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory FoodItemModel.fromMap(Map<String, dynamic> map) => FoodItemModel(
        id: map['id'] as String,
        tripId: map['trip_id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        area: map['area'] as String?,
        address: map['address'] as String?,
        recommendedDish: map['recommended_dish'] as String?,
        budget: (map['budget'] as num?)?.toDouble(),
        actualCost: (map['actual_cost'] as num?)?.toDouble(),
        note: map['note'] as String?,
        status: map['status'] as String?,
        rating: map['rating'] as int?,
        createdAt: map['created_at'] as String? ?? '',
        updatedAt: map['updated_at'] as String? ?? '',
      );
}
