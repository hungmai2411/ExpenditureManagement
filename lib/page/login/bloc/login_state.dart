enum Social { email, google, facebook, newUser }

abstract class LoginState {}

class InitState extends LoginState {}

class LoginSuccessState extends LoginState {
  final Social social;
  final bool isNewUser;
  LoginSuccessState({
    required this.social,
    required this.isNewUser,
  });
}

class LoginErrorState extends LoginState {
  String status;
  LoginErrorState({required this.status});
}
