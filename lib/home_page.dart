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


  User? user = FirebaseAuth.instance.currentUser;
  late final email = user!.email;
  late final password = widget.pass;


  final loginAndPasswordStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  final welcomeStyle = const TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
  final emailAndPasswordStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.w400);



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
              child: const Text('Logout', style: TextStyle(color: Colors.white))
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
                Text('Login:', style: loginAndPasswordStyle),
                const SizedBox(width: 15),
                Text('$email', style: emailAndPasswordStyle)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Password:', style: loginAndPasswordStyle),
                const SizedBox(width: 15),
                Text('$password', style: emailAndPasswordStyle,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


  void logOutButton(){
    AuthService().logOut();
    Navigator.pop(context);
  }
}
