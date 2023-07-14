import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.text, required this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
          highlightElevation: 5,
          onPressed: () => onPressed(),
          child: Container(
            height: 55,
            width: double.infinity,
            child: Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          )),
    );
  }
}
