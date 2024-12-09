class User {
  final String id;
  final String name;
  final String email;
  final String? password; // Opcional: usado apenas para atualização de senha
  final DateTime? dateOfBirth; // Tornado opcional

  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      dateOfBirth: json['dateOfBirth'] != null && json['dateOfBirth'] != ""
          ? DateTime.parse(json['dateOfBirth'])
          : null, // Trata a ausência ou string vazia do campo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      if (password != null) 'password': password,
      if (dateOfBirth != null)
        'dateOfBirth': dateOfBirth!.toIso8601String(),
    };
  }
}
