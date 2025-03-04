// 1 Provider state

import 'package:teslo_shop/features/shared/shared.dart';

class LoginFormProvider {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormProvider({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure() ,
    this.password = const Password.pure(),
  });
}

// 2 How to implement the Notifier

// 3 StateNotifierProvider - this is consumed outside