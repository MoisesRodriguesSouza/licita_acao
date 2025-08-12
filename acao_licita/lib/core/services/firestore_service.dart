// lib/core/services/firestore_service.dart
// Serviço para interagir com o Firebase Firestore.
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/process.dart'; // Importa o modelo de Process
import '../models/user.dart'; // Importa o modelo de User
import '../models/renewal.dart'; // Importa o modelo de Renewal

class FirestoreService {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance; // Instância do Firestore

  // --- Operações para Processos ---

  // Obtém um stream de todos os processos
  Stream<List<Process>> getProcesses() {
    return _db
        .collection('processes')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Process.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Obtém um stream de um processo específico por ID
  Stream<Process?> getProcessById(String id) {
    return _db.collection('processes').doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return Process.fromFirestore(snapshot.data()!, snapshot.id);
    });
  }

  // Adiciona um novo processo
  Future<void> addProcess(Process process) {
    return _db.collection('processes').add(process.toFirestore());
  }

  // Atualiza um processo existente
  Future<void> updateProcess(Process process) {
    return _db
        .collection('processes')
        .doc(process.id)
        .update(process.toFirestore());
  }

  // Elimina um processo
  Future<void> deleteProcess(String id) {
    return _db.collection('processes').doc(id).delete();
  }

  // --- Operações para Utilizadores (User) ---

  // Obtém um utilizador por ID
  Future<User?> getUserById(String id) async {
    final doc = await _db.collection('users').doc(id).get();
    if (!doc.exists) {
      return null;
    }
    return User.fromFirestore(doc.data()!);
  }

  // Adiciona ou atualiza um utilizador
  Future<void> saveUser(User user) {
    return _db.collection('users').doc(user.id).set(user.toFirestore());
  }

  // --- Operações para Renovações/Aditivos ---

  // Obtém um stream de renovações/aditivos para um processo específico
  Stream<List<Renewal>> getRenewalsForProcess(String processId) {
    return _db
        .collection('renewals_additives')
        .where('processId', isEqualTo: processId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Renewal.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Adiciona uma nova renovação/aditivo
  Future<void> addRenewal(Renewal renewal) {
    return _db.collection('renewals_additives').add(renewal.toFirestore());
  }

  // Atualiza uma renovação/aditivo
  Future<void> updateRenewal(Renewal renewal) {
    return _db
        .collection('renewals_additives')
        .doc(renewal.id)
        .update(renewal.toFirestore());
  }

  // Elimina uma renovação/aditivo
  Future<void> deleteRenewal(String id) {
    return _db.collection('renewals_additives').doc(id).delete();
  }
}
