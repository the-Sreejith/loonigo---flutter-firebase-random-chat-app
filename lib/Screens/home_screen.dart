import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Column(
        children: [
          Text('$newMethod!'),
          Center(
            child: ElevatedButton(onPressed: (){
              FirebaseAuth.instance.signOut().whenComplete(
                (){
                  Navigator.pushNamed(context, '/anonymous_login');
                }
              );
            }, child: Text("Log out")),
          )
        ],
      ),
    );
  }

  String? get newMethod => user.uid;
}