// lib/core/models/renewal.dart
// Modelo de dados para renovações e aditivos contratuais.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar para usar Timestamp

class Renewal {
  final String id;
  final String processId; // ID do processo de licitação associado
  final String type; // Ex: '1st_renewal', 'Aditivo'
  final DateTime dataInicio;
  final DateTime dataTermino;
  final double? valorAditivo; // Opcional, se for um aditivo de valor
  final String? observation; // Observações sobre a renovação/aditivo
  final bool isCompliantLaw14133; // Indica conformidade com a Lei 14.133/2021

  Renewal({
    required this.id,
    required this.processId,
    required this.type,
    required this.dataInicio,
    required this.dataTermino,
    this.valorAditivo,
    this.observation,
    required this.isCompliantLaw14133,
  });

  factory Renewal.fromFirestore(Map<String, dynamic> data, String id) {
    return Renewal(
      id: id,
      processId: data['processId'] ?? '',
      type: data['type'] ?? '',
      dataInicio: (data['dataInicio'] as Timestamp).toDate(),
      dataTermino: (data['dataTermino'] as Timestamp).toDate(),
      valorAditivo: (data['valorAditivo'] as num?)?.toDouble(),
      observation: data['observation'],
      isCompliantLaw14133: data['isCompliantLaw14133'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'processId': processId,
      'type': type,
      'dataInicio': Timestamp.fromDate(dataInicio),
      'dataTermino': Timestamp.fromDate(dataTermino),
      'valorAditivo': valorAditivo,
      'observation': observation,
      'isCompliantLaw14133': isCompliantLaw14133,
    };
  }
}
