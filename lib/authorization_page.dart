import 'package:authorization/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'home_page.dart';





class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late String _email;
  late String _password;

  late final pass;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text('Authorization'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: Center(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: validateEmail,
                    decoration: const InputDecoration(labelText: 'Email'),
                    controller: emailController,
                  ),
                  TextFormField(
                    validator: validatePassword,
                    decoration: const InputDecoration(labelText: 'Password'),
                    controller: passwordController,
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                      onPressed:() {
                        if (formKey.currentState!.validate()) {
                          logInButton();
                        }
                      },
                      child: const Text(
                          'LOGIN', style: TextStyle(fontSize: 16)
                      )
                  ),
                  ElevatedButton(
                      onPressed:() {
                        if (formKey.currentState!.validate()) {
                          registerButton();
                        }
                      },
                      child: const Text('Registration')
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }




  void logInButton() async {

    final AuthService _authService = AuthService();

    _email = emailController.text;
    _password = passwordController.text;

    try {
      await _authService.signIn(_email.trim(), _password.trim());
      final pass = await _authService.passwordToHomePage(_password);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage(pass: pass))
      );

      emailController.clear();
      passwordController.clear();

    } on FirebaseAuthException catch(e) {
      if(e.message == 'The password is invalid or the user does not have a password.'){
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return invalidPassword;
            }
        );
      }
      else {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return userNotRegister;
            }
        );
      }
    }
  }


  void registerButton() async{

    final AuthService _authService = AuthService();

    _email = emailController.text;
    _password = passwordController.text;


    User? user = await _authService.register(_email.trim(), _password.trim());
    if(user == null) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return userAlredyRegister;
          }
      );
    }
    else{
      final pass = await _authService.passwordToHomePage(_password);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(pass: pass)));

      emailController.clear();
      passwordController.clear();

    }
  }
}






