class User {
  final String id;
  final String email;
  final String displayName;
  final String role; // e.g., 'admin', 'gestor'
  final String setorId;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.setorId,
  });

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      email: data['email'],
      displayName: data['displayName'],
      role: data['role'],
      setorId: data['setorId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'role': role,
      'setorId': setorId,
    };
  }
}
