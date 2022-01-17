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
            child: Container(
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



  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late String _email;
  late String _password;


  final AuthService _authService = AuthService();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  void logInButton() async{
    _email = emailController.text;
    _password = passwordController.text;

    User? user = await _authService.signIn(_email.trim(), _password.trim());


    if(user == null){
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                height: 200,
                child: const Text(
                  'Данный пользователь не зарегестрирован',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                )
            );
          }
      );
    }else {
      final pass = await _authService.passwordToHomePage(_password);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(pass: pass)));
      emailController.clear();
      passwordController.clear();
    }
  }


  void registerButton() async{
    _email = emailController.text;
    _password = passwordController.text;


    User? user = await _authService.register(_email.trim(), _password.trim());
    if(user == null) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                height: 200,
                child: const Text(
                  'Данный пользователь уже зарегестрирован',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                )
            );
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



String? validateEmail(String? formEmail){
  if(formEmail == null || formEmail.isEmpty) return "Error";
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if(!regex.hasMatch(formEmail)) return 'Invalid Email address format';
  return null;
}


String? validatePassword(String? formPassword){
  if(formPassword == null || formPassword.isEmpty) return "Error";
  String pattern = r'^.{6,}$';
  RegExp regex = RegExp(pattern);
  if(!regex.hasMatch(formPassword)) return 'Password must be at least 6 characters';
  return null;
}


