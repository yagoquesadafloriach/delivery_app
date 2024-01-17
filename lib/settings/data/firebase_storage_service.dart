import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> setProfileImage({required Uint8List imageBytes, required String userId}) async {
    try {
      final imagePath = '$userId.jpg';
      final storageReference = _storage.ref().child(imagePath);

      await storageReference.putData(imageBytes);

      final imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (error) {
      log('Error - $error');
      rethrow;
    }
  }

  Future<dynamic> getProfileImage({required String? userId}) async {
    try {
      if (userId == null) return;

      final downloadURL = await _getDownloadURL(userId: userId);

      return downloadURL;
    } catch (error) {
      log('Error - $error');
      return null;
    }
  }

  Future<String> _getDownloadURL({required String userId}) {
    return _storage.ref().child('$userId.jpg').getDownloadURL();
  }
}
