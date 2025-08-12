// lib/core/models/user.dart
// Modelo de dados para o utilizador da aplicação.
class User {
  final String id;
  final String email;
  final String displayName;
  final String role; // Ex: 'admin', 'gestor', 'assessor'
  final String setorId; // ID do setor ao qual o utilizador pertence

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.setorId,
  });

  // Construtor de fábrica para criar um objeto User a partir de um mapa (ex: Firestore)
  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '', // Fornece um valor padrão caso 'id' seja nulo
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      role: data['role'] ?? 'assessor', // Role padrão como 'assessor'
      setorId: data['setorId'] ?? '',
    );
  }

  // Converte o objeto User para um mapa (ex: para salvar no Firestore)
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
