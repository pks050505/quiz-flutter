import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cource_todo_2/exceptions/custom_exception.dart';
import 'package:flutter_cource_todo_2/providers/general_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseAuthRepository {
  Future<void> signInAnounmously();
  User? getCurrentUser();
  Stream<User?> get authStateChanges;
  Future<void> signOut();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read);
});

class AuthRepository extends BaseAuthRepository {
  final Reader _read;
  AuthRepository(this._read);
  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signInAnounmously() async {
    try {
      await _read(firebaseAuthProvider).signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _read(firebaseAuthProvider).signOut();
      await signInAnounmously();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
