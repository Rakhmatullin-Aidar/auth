import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key, this.pass}) : super(key: key);

  final pass;

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter login demo'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: logOutButton,
              child: const Text(
                  'Logout', style: TextStyle(color: Colors.white)
              )
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Welcome', style: welcomeStyle
            ),
            const Divider(height: 100, color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Login:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(width: 15),
                Text(
                  '${user!.email}',
                  style: emailAndPasswordStyle,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Password:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(width: 15),
                Text(
                  '${widget.pass}',
                  style: emailAndPasswordStyle,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


  final welcomeStyle = const TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  final emailAndPasswordStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

  User? user = FirebaseAuth.instance.currentUser;


  void logOutButton(){
    AuthService().logOut();
    Navigator.pop(context);
  }
}
