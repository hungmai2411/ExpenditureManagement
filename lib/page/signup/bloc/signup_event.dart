import 'package:expenditure_management/models/user.dart';

abstract class SignupEvent {}

class SignupEmailPasswordEvent extends SignupEvent {
  final User user;

  SignupEmailPasswordEvent({required this.user});
}
