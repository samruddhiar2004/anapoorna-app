import 'package:firebase_auth/firebase_auth.dart' as auth;

// Create a simple User class to avoid conflicts or use Firebase User directly
typedef User = auth.User;

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Sign in anon (for testing)
  Future signInAnon() async {
    try {
      auth.UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}