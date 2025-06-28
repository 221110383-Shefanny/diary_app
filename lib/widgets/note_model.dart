import 'canvas_elements.dart';

class Note {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<CanvasElement> elements;
  final String userId;

  Note({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.elements,
    required this.userId,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'userId': userId,
        'elements': elements.map((e) => e.toJson()).toList(),
      };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'] ?? '',
      elements: (json['elements'] as List<dynamic>)
          .map((e) => CanvasElement.fromJson(e))
          .toList(),
    );
  }

  Note copyWith({String? id}) => Note(
        id: id ?? this.id,
        title: title,
        createdAt: createdAt,
        elements: elements,
        userId: userId,
      );
}
