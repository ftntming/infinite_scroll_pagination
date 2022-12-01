/// Summarized information of a user.
class UserSummary {
  UserSummary({
    required this.id,
    required this.name,
    required this.pictureUrl,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) => UserSummary(
        id: json['char_id'],
        name: json['name'],
        pictureUrl: json['img'],
      );

  final int id;
  final String name;
  final String pictureUrl;
}
