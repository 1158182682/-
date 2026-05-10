class TripModel {
  final String id;
  final String title;
  final String destination;
  final String? startDate;
  final String? endDate;
  final String createdAt;
  final String updatedAt;

  const TripModel({
    required this.id,
    required this.title,
    required this.destination,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'destination': destination,
        'start_date': startDate,
        'end_date': endDate,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory TripModel.fromMap(Map<String, dynamic> map) => TripModel(
        id: map['id'] as String,
        title: map['title'] as String? ?? '',
        destination: map['destination'] as String? ?? '',
        startDate: map['start_date'] as String?,
        endDate: map['end_date'] as String?,
        createdAt: map['created_at'] as String? ?? '',
        updatedAt: map['updated_at'] as String? ?? '',
      );
}
