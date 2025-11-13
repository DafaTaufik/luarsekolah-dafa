import 'package:luarsekolah/features/class/domain/entities/course_entity.dart';

class Course extends CourseEntity {
  const Course({
    required super.id,
    required super.name,
    required super.price,
    required super.categoryTag,
    required super.createdAt,
    required super.updatedAt,
    super.thumbnail,
    super.rating,
    super.createdBy,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as String,
      categoryTag:
          (json['categoryTag'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      thumbnail: json['thumbnail'] as String?,
      rating: json['rating'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'categoryTag': categoryTag,
      'thumbnail': thumbnail,
      'rating': rating,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
