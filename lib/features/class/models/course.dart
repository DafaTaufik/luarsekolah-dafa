class Course {
  final String id;
  final String name;
  final String price;
  final List<String> categoryTag;
  final String? thumbnail;
  final String? rating;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryTag,
    this.thumbnail,
    this.rating,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
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

class CourseListResponse {
  final List<Course> courses;
  final int total;

  CourseListResponse({required this.courses, required this.total});

  factory CourseListResponse.fromJson(Map<String, dynamic> json) {
    return CourseListResponse(
      courses: (json['courses'] as List<dynamic>)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }
}

class CreateCourseRequest {
  final String name;
  final String? price;
  final List<String>? categoryTag;
  final String? thumbnail;
  final String? rating;

  CreateCourseRequest({
    required this.name,
    this.price,
    this.categoryTag,
    this.thumbnail,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'name': name};

    if (price != null) map['price'] = price;
    if (categoryTag != null) map['categoryTag'] = categoryTag;
    if (thumbnail != null) map['thumbnail'] = thumbnail;
    if (rating != null) map['rating'] = rating;

    return map;
  }
}

class UpdateCourseRequest {
  final String? name;
  final String? price;
  final List<String>? categoryTag;
  final String? thumbnail;
  final String? rating;

  UpdateCourseRequest({
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
