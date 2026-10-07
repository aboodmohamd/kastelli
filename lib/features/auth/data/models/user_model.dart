class UserModel {
  final String name;
  final String email;
  final String userId;
  final String countryCode;
  final String telephone;
  final int newsLetter;
  final String dateOfBirth;

  UserModel({
    required this.name,
    required this.email,
    required this.userId,
    required this.countryCode,
    required this.telephone,
    required this.newsLetter,
    required this.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userId: json['user_id']?.toString() ?? '',
      countryCode: json['country_code'] ?? '',
      telephone: json['telephone']?.toString() ?? '',
      newsLetter: json['newsletter'] ?? 0,
      dateOfBirth: json['date_of_birth'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'telephone_extension': countryCode,
      'telephone': telephone,
      'newsletter': newsLetter,
      if (dateOfBirth.isNotEmpty) 'date_of_birth': dateOfBirth,
    };
  }
}
