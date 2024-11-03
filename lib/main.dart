import 'package:flutter/material.dart';
import 'package:loonigo/Screens/chat_screen.dart';
import 'package:loonigo/Screens/anonymous_login.dart';
import 'package:loonigo/Screens/home_screen.dart';
import 'package:loonigo/Screens/onboarding_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Loonigo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthGate(),
        routes: {
          '/onboarding': (context) => OnboardingScreen(),
          '/anonymous_login': (context) => AnonymousLoginScreen(),
          '/chat_screen': (context) => MessagesScreen(),
          '/home_screen': (context) => HomeScreen(user: ModalRoute.of(context)?.settings.arguments)
        });
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // User is signed in
          if (snapshot.hasData) {
            return HomeScreen(user: snapshot.data!); 
          } else {
            // User is not signed in
            return OnboardingScreen(); 
          }
        } else {
          // Connection state is not active
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
