import 'package:expenditure_management/page/login/widget/custom_button.dart';
import 'package:expenditure_management/page/login/widget/input_password.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hide = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)
                    .translate('you_want_change_your_password'),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                textAlign: TextAlign.center,
                AppLocalizations.of(context)
                    .translate('please_enter_your_current_password'),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 50),
              inputPassword(
                hint: "Password",
                controller: _passwordController,
                hide: hide,
                action: () {
                  setState(() => hide = !hide);
                },
              ),
              const SizedBox(height: 30),
              customButton(
                action: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      final credential = EmailAuthProvider.credential(
                        email: user!.email!,
                        password: _passwordController.text,
                      );
                      var result =
                          await user.reauthenticateWithCredential(credential);
                      if (result.user != null) {
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(context, '/new');
                      } else {
                        if (!mounted) return;
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)
                              .translate("incorrect_password"),
                        );
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                    return;
                  }
                },
                text: AppLocalizations.of(context).translate('submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
