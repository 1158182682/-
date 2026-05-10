class NoteModel {
  final String id;
  final String tripId;
  final String type;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  const NoteModel({
    required this.id,
    required this.tripId,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'trip_id': tripId,
        'type': type,
        'title': title,
        'content': content,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  factory NoteModel.fromMap(Map<String, dynamic> map) => NoteModel(
        id: map['id'] as String,
        tripId: map['trip_id'] as String? ?? '',
        type: map['type'] as String? ?? '',
        title: map['title'] as String? ?? '',
        content: map['content'] as String? ?? '',
        createdAt: map['created_at'] as String? ?? '',
        updatedAt: map['updated_at'] as String? ?? '',
      );
}
