import 'package:expenditure_management/firebase_options.dart';
import 'package:expenditure_management/page/forgot/forgot_page.dart';
import 'package:expenditure_management/page/forgot/success_page.dart';
import 'package:expenditure_management/page/login/login_page.dart';
import 'package:expenditure_management/page/main/home/home_page.dart';
import 'package:expenditure_management/page/main/main_page.dart';
import 'package:expenditure_management/page/onboarding/onboarding_page.dart';
import 'package:expenditure_management/page/signup/signup_page.dart';
import 'package:expenditure_management/page/signup/verify/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spending Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? "/"
          : (FirebaseAuth.instance.currentUser!.emailVerified
              ? '/main'
              : '/verify'),
      routes: {
        '/': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/main': (context) => const MainPage(),
        '/forgot': (context) => const ForgotPage(),
        '/success': (context) => const SuccessPage(),
        '/verify': (context) => const VerifyPage()
      },
    );
  }
}
