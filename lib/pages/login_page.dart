import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //dispose
  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  //login method
  void login(BuildContext context) async {
    //auth service
    final AuthService authService = AuthService();

    //try login
    try{
      await authService.signInWithEmailPassword(_emailController.text.trim(), _passwordController.text.trim());
    } catch(e){
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(Icons.message, size: 60, color: Theme.of(context).colorScheme.primary),

            const SizedBox(height: 30),
            //welcome back message
            Text(
              'Welcome back, you have been missed!',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),

            const SizedBox(height: 30),
            //email text
            MyTextField(hintText: 'Email', obscureText: false, controller: _emailController),
            const SizedBox(height: 12),

            //password text
            MyTextField(hintText: 'Password', obscureText: true, controller: _passwordController),
            const SizedBox(height: 12),
            //login button
            MyButton(text: 'Login', onTap: () => login(context)),
            const SizedBox(height: 20),

            //register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Register now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
