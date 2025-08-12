// lib/core/services/storage_service.dart
// Serviço para lidar com o armazenamento de ficheiros no Firebase Storage.
import 'dart:io'; // Para File
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p; // Para manipulação de caminhos

class StorageService {
  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Instância do Firebase Storage

  // Carrega um ficheiro para o Firebase Storage
  // Retorna a URL de download do ficheiro
  Future<String> uploadFile(File file, String path) async {
    try {
      // Cria uma referência para o local onde o ficheiro será guardado
      // Ex: 'process_attachments/process_id/nome_do_ficheiro.pdf'
      final String fileName = p.basename(file.path);
      final Reference ref = _storage.ref().child('$path/$fileName');

      // Carrega o ficheiro
      final UploadTask uploadTask = ref.putFile(file);

      // Espera pela conclusão do carregamento e obtém a URL de download
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Erro ao carregar ficheiro: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao carregar ficheiro: $e');
    }
  }

  // Elimina um ficheiro do Firebase Storage usando a sua URL
  Future<void> deleteFile(String fileUrl) async {
    try {
      // Cria uma referência a partir da URL de download
      final Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw Exception('Erro ao eliminar ficheiro: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao eliminar ficheiro: $e');
    }
  }
}
