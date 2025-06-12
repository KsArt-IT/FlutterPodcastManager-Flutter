import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final String id;
  final String title;
  final String description;
  final String host;
  final DateTime? createdAt;

  const Episode({
    this.id = '',
    required this.title,
    required this.description,
    required this.host,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, host];

  Episode copyWith({
    String? id,
    String? title,
    String? description,
    String? host,
    DateTime? createdAt,
  }) {
    return Episode(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      host: host ?? this.host,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
