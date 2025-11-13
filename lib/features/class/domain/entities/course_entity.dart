import 'package:flutter/foundation.dart';

//immutable mean that once an instance of this class is created, its state cannot be changed.
@immutable
class CourseEntity {
  const CourseEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryTag,
    required this.createdAt,
    required this.updatedAt,
    this.thumbnail,
    this.rating,
    this.createdBy,
  });

  //Final. The variable cannot be reassigned after it is initialized
  final String id;
  final String name;
  final String price;
  final List<String> categoryTag;
  final String? thumbnail;
  final String? rating;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Creates a copy of this entity with the given fields replaced by the new values.
  CourseEntity copyWith({
    String? id,
    String? name,
    String? price,
    List<String>? categoryTag,
    String? thumbnail,
    String? rating,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryTag: categoryTag ?? this.categoryTag,
      thumbnail: thumbnail ?? this.thumbnail,
      rating: rating ?? this.rating,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  //This for equality comparison between two CourseEntity instances. The comparation is using of their data.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseEntity &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        listEquals(other.categoryTag, categoryTag) &&
        other.thumbnail == thumbnail &&
        other.rating == rating &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  //Because we override "==" operator, we also need to override hashCode. Mean a.hascode == b.hascode must true
  @override
  int get hashCode => Object.hash(
    id,
    name,
    price,
    Object.hashAll(categoryTag),
    thumbnail,
    rating,
    createdBy,
    createdAt,
    updatedAt,
  );

  //And this for debugging purposes. Because when we print an object, it will call toString() method.
  @override
  String toString() {
    return 'CourseEntity(id: $id, name: $name, price: $price, '
        'categoryTag: $categoryTag, thumbnail: $thumbnail, '
        'rating: $rating, createdBy: $createdBy, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
