abstract class RegisterRepository {
  Future<void> registerUser(String email, String password);
}

class RegisterRepositoryImpl implements RegisterRepository {
  @override
  Future<void> registerUser(String email, String password) async {
    // Simulate a network call or database operation
    await Future.delayed(const Duration(seconds: 2));
    // Here you would typically call your backend service to register the user
    print('User registered with email: $email');
  }
}