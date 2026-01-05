import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_textfield.dart';

import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPwController.dispose();
  }

  //register method
  void register(BuildContext context) async {
    final AuthService auth = AuthService();

    //password match -> create user
    if(_passwordController.text.trim()== _confirmPwController.text.trim()){
      try{
        await auth.signUpWithEmailPassword(_emailController.text.trim(), _passwordController.text.trim());
      } catch(e){
        showDialog(context: context, builder: (context) => AlertDialog(title: Text(e.toString()),));
      }
    }

    //password don't match -> show error to user (nếu confirm password không đúng, báo lỗi)
    else{
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Password don't match"),
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
              'Let create an account for you!',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),

            const SizedBox(height: 30),
            //email text
            MyTextField(hintText: 'Email', obscureText: false, controller: _emailController),
            const SizedBox(height: 12),

            //password text
            MyTextField(hintText: 'Password', obscureText: true, controller: _passwordController),
            const SizedBox(height: 12),
            
            MyTextField(hintText: "Confirm password", obscureText: true, controller: _confirmPwController),
            const SizedBox(height: 12),
            //login button
            MyButton(text: 'Register', onTap: () => register(context)),
            const SizedBox(height: 20),

            //register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Login now',
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
