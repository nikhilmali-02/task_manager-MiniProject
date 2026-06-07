import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  Future<void> signUp(String email,String password)async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password
      );
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email,String password)async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password
      );
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<void> signOut()async {
    try{
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

}