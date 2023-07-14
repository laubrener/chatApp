import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_labels.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:chat_app/widgets/login_button.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Logo(title: "Sign Up"),
                  _Form(),
                  LoginLabels(
                      page: "login",
                      text: "Already have an account",
                      btn: "Login"),
                  Text("Terms and conditions")
                ]),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: "Name",
            keyboardType: TextInputType.text,
            textController: nameController,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: "Email",
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: "Password",
            keyboardType: TextInputType.visiblePassword,
            textController: passwordController,
          ),
          LoginButton(
            text: "Login",
            onPressed: () {
              print(emailController.text);
              print(passwordController.text);
            },
          )
        ],
      ),
    );
  }
}
