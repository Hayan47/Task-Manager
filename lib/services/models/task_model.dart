import 'package:equatable/equatable.dart';

class Data {
  int page;
  int perPage;
  int total;
  int totalPages;
  List<Task> data;

  Data({
    this.page = 0,
    this.perPage = 0,
    this.total = 0,
    this.totalPages = 0,
    this.data = const [],
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      page: json['page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Task extends Equatable {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;

  Task({
    this.id = 0,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.avatar = '',
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatar];
}
