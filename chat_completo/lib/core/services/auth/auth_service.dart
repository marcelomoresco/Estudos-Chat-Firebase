import 'dart:io';

import 'package:chat_completo/core/services/auth/auth_service_firebase.dart';

import '../../models/chat_user.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?> get UserChanges;

  Future<void> signUp(
    String name,
    String email,
    String password,
    File? image,
  );

  Future<void> login(
    String email,
    String password,
  );

  Future<void> logout();

  factory AuthService() {
    //return AuthMockService();
    return AuthFirebaseService();
  }
}
