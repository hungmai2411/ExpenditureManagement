import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expenditure_management/constants/app_styles.dart';

class InputPassword extends StatelessWidget {
  const InputPassword({
    Key? key,
    required this.hint,
    this.error,
    required this.controller,
    this.password,
    required this.hide,
    required this.action,
  }) : super(key: key);

  final String hint;
  final String? error;
  final TextEditingController controller;
  final TextEditingController? password;
  final bool hide;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: hide,
      style: AppStyles.p,
      validator: (value) {
        if (password != null &&
                password!.text.toString() != controller.text.toString() ||
            password != null && value!.isEmpty) {
          return 'Enter a valid confirm password!';
        }

        if (value!.isEmpty && password == null) {
          return 'Enter a valid password!';
        }

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
        hintStyle: AppStyles.p,
        filled: true,
        fillColor: Theme.of(context).backgroundColor,
        hintText: hint,
        errorText: error,
        suffixIcon: IconButton(
          onPressed: () {
            action();
          },
          splashColor: Colors.transparent,
          icon: Icon(
            hide ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
            size: 20,
          ),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
