// lib/core/providers/process_provider.dart
// Provedores Riverpod para gerenciar dados de processos de licitação.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/process.dart';
import '../services/firestore_service.dart'; // Importar o serviço Firestore

// Provedor que expõe o serviço Firestore para operações de processo
final processServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(); // Instancia o serviço Firestore
});

// Exemplo de provedor para obter uma lista de todos os processos
final processesStreamProvider = StreamProvider<List<Process>>((ref) {
  final firestoreService = ref.watch(processServiceProvider);
  return firestoreService.getProcesses();
});

// Exemplo de provedor para obter um único processo por ID
final singleProcessProvider = StreamProvider.family<Process?, String>((
  ref,
  processId,
) {
  final firestoreService = ref.watch(processServiceProvider);
  return firestoreService.getProcessById(processId);
});
