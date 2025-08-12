// lib/core/models/process.dart
// Modelo de dados para um processo de licitação.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar para usar Timestamp

class Process {
  final String id;
  final String numeroProcesso;
  final String objetoLicitacao;
  final String setorDemandanteId;
  final String assessorTecnicoId;
  final String modalidade;
  final String tipoContratacao;
  final String faseAtual;
  final String observacoes;
  final DateTime dataAbertura;
  final DateTime dataPrevistaConclusao;
  final DateTime? dataRealConclusao; // Pode ser nulo se não concluído
  final String? motivoAtraso; // Pode ser nulo
  final String status; // Ex: 'Em Andamento', 'Parado', 'Finalizado'
  final DateTime lastUpdated;
  final List<Map<String, String>> attachments; // Lista de mapas com nome e URL

  Process({
    required this.id,
    required this.numeroProcesso,
    required this.objetoLicitacao,
    required this.setorDemandanteId,
    required this.assessorTecnicoId,
    required this.modalidade,
    required this.tipoContratacao,
    required this.faseAtual,
    required this.observacoes,
    required this.dataAbertura,
    required this.dataPrevistaConclusao,
    this.dataRealConclusao,
    this.motivoAtraso,
    required this.status,
    required this.lastUpdated,
    this.attachments = const [],
  });

  factory Process.fromFirestore(Map<String, dynamic> data, String id) {
    return Process(
      id: id,
      numeroProcesso: data['numeroProcesso'] ?? '',
      objetoLicitacao: data['objetoLicitacao'] ?? '',
      setorDemandanteId: data['setorDemandanteId'] ?? '',
      assessorTecnicoId: data['assessorTecnicoId'] ?? '',
      modalidade: data['modalidade'] ?? '',
      tipoContratacao: data['tipoContratacao'] ?? '',
      faseAtual: data['faseAtual'] ?? '',
      observacoes: data['observacoes'] ?? '',
      dataAbertura: (data['dataAbertura'] as Timestamp).toDate(),
      dataPrevistaConclusao: (data['dataPrevistaConclusao'] as Timestamp)
          .toDate(),
      dataRealConclusao: data['dataRealConclusao'] != null
          ? (data['dataRealConclusao'] as Timestamp).toDate()
          : null,
      motivoAtraso: data['motivoAtraso'],
      status: data['status'] ?? '',
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      attachments: List<Map<String, String>>.from(data['attachments'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'numeroProcesso': numeroProcesso,
      'objetoLicitacao': objetoLicitacao,
      'setorDemandanteId': setorDemandanteId,
      'assessorTecnicoId': assessorTecnicoId,
      'modalidade': modalidade,
      'tipoContratacao': tipoContratacao,
      'faseAtual': faseAtual,
      'observacoes': observacoes,
      'dataAbertura': Timestamp.fromDate(dataAbertura),
      'dataPrevistaConclusao': Timestamp.fromDate(dataPrevistaConclusao),
      'dataRealConclusao': dataRealConclusao != null
          ? Timestamp.fromDate(dataRealConclusao!)
          : null,
      'motivoAtraso': motivoAtraso,
      'status': status,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'attachments': attachments,
    };
  }
}
