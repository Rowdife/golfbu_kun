import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;
  User? get user => _firebaseAuth.currentUser;

  Future<void> signUp(String email, String password) async {
    print(email);

    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    print("successfully done2");
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());
