import '../domain/models/user.dart';

abstract interface class AuthService {
  Future<User?> signIn(String identifier, String password);
  Future<void> signOut();
}
