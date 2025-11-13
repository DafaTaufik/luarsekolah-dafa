/// Request model for creating and updating courses
class CourseRequest {
  final String? name;
  final String? price;
  final List<String>? categoryTag;
  final String? thumbnail;
  final String? rating;

  const CourseRequest({
    this.name,
    this.price,
    this.categoryTag,
    this.thumbnail,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (name != null) map['name'] = name;
    if (price != null) map['price'] = price;
    if (categoryTag != null) map['categoryTag'] = categoryTag;
    if (thumbnail != null) map['thumbnail'] = thumbnail;
    if (rating != null) map['rating'] = rating;

    return map;
  }
}
