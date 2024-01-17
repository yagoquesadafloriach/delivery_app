import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.photo,
  });

  factory User.fromJson(String id, Map<String, dynamic> json) {
    json['id'] = id;
    if (json['email'] == null) json['email'] = '';
    if (json['photo'] == null) json['photo'] = '';
    return _$UserFromJson(json);
  }

  final String id;
  final String? email;
  final String? photo;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, email, photo];
}
