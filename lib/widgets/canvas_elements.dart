import 'dart:ui';
import 'package:flutter/material.dart';

abstract class CanvasElement {
  String get id;

  Map<String, dynamic> toJson();
  CanvasElement clone();

  static CanvasElement fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'text':
        return TextElement.fromJson(json);
      case 'image':
        return ImageElement.fromJson(json);
      default:
        throw Exception('Unknown element type: ${json['type']}');
    }
  }
}

// 🎨 TEXT ELEMENT ----------------------------------------

class TextElement extends CanvasElement {
  @override
  final String id;
  final String text;
  final Offset position;
  final TextStyle style;

  TextElement({
    required this.id,
    required this.text,
    required this.position,
    required this.style,
  });

  @override
  Map<String, dynamic> toJson() => {
        'type': 'text',
        'id': id,
        'text': text,
        'position': {'dx': position.dx, 'dy': position.dy},
        'style': {
          'fontSize': style.fontSize,
          'fontWeight': style.fontWeight.toString(),
          'color': style.color?.value,
        },
      };

  static TextElement fromJson(Map<String, dynamic> json) {
    final s = json['style'];
    return TextElement(
      id: json['id'],
      text: json['text'],
      position: Offset(json['position']['dx'], json['position']['dy']),
      style: TextStyle(
        fontSize: (s['fontSize'] ?? 20).toDouble(),
        fontWeight: FontWeight.values.firstWhere(
          (w) => w.toString() == s['fontWeight'],
          orElse: () => FontWeight.normal,
        ),
        color: s['color'] != null ? Color(s['color']) : Colors.black,
      ),
    );
  }

  @override
  CanvasElement clone() => TextElement(
        id: id,
        text: text,
        position: position,
        style: style,
      );

  TextElement copyWith({
    String? id,
    String? text,
    Offset? position,
    TextStyle? style,
  }) {
    return TextElement(
      id: id ?? this.id,
      text: text ?? this.text,
      position: position ?? this.position,
      style: style ?? this.style,
    );
  }
}

// 🖼️ IMAGE ELEMENT ----------------------------------------

class ImageElement extends CanvasElement {
  @override
  final String id;
  final String imageUrl;
  final Offset position;
  final Size size;

  ImageElement({
    required this.id,
    required this.imageUrl,
    required this.position,
    required this.size,
  });

  @override
  Map<String, dynamic> toJson() => {
        'type': 'image',
        'id': id,
        'imageUrl': imageUrl,
        'position': {'dx': position.dx, 'dy': position.dy},
        'size': {'width': size.width, 'height': size.height},
      };

  static ImageElement fromJson(Map<String, dynamic> json) {
    return ImageElement(
      id: json['id'],
      imageUrl: json['imageUrl'],
      position: Offset(json['position']['dx'], json['position']['dy']),
      size: Size(json['size']['width'], json['size']['height']),
    );
  }

  @override
  CanvasElement clone() => ImageElement(
        id: id,
        imageUrl: imageUrl,
        position: position,
        size: size,
      );

  ImageElement copyWith({
    String? id,
    String? imageUrl,
    Offset? position,
    Size? size,
  }) {
    return ImageElement(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}
