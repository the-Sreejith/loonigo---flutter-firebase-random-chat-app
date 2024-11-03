import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class AnonymousLoginScreen extends StatefulWidget {
  const AnonymousLoginScreen({super.key});

  @override
  State<AnonymousLoginScreen> createState() => _AnonymousLoginScreenState();
}

class _AnonymousLoginScreenState extends State<AnonymousLoginScreen> {
  String selectedGender = 'Male';
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Yourself?",
          style: TextStyle(color: Color(0xFF757575)),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please enter your name",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your name',
                    ),
                    controller: nameController,
                  ),
                  const Text(
                    "Please select your gender",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  DropdownButton<String>(
                    value: selectedGender,
                    items: <String>['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (changedValue) {
                      if (changedValue != selectedGender &&
                          changedValue != null) {
                        setState(() {
                          selectedGender = changedValue;
                        });
                      }
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your Age',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(),
                    controller: ageController,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.trim() != '') {
                        try {
                          final userCredential =
                              await FirebaseAuth.instance.signInAnonymously();
                          if (userCredential.user != null) {
                            User user = userCredential.user!;

                            Navigator.pushReplacementNamed(
                                context, '/home_screen',
                                arguments: user);

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .set({
                              'uid': user.uid,
                              'name': nameController.text,
                              'age': ageController.text,
                              'gender': selectedGender,
                              'signInMethod': 'anonymous',
                              'timestamp': Timestamp.now()
                            });

                            FirebaseFirestore.instance
                                .collection('userPool')
                                .doc(selectedGender.toLowerCase())
                                .collection('users')
                                .doc(user.uid)
                                .set({
                              'uid': user.uid,
                              'name': nameController.text,
                              'age': ageController.text,
                              'gender': selectedGender,
                              'timestamp': Timestamp.now()
                            });
                          }
                        } on FirebaseAuthException catch (e) {
                          print("Error signing in anonymously: ${e.message}");
                        }
                      }
                    },
                    child: Center(child: Text("Login")),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  // const ForgotPasswordForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  // const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
