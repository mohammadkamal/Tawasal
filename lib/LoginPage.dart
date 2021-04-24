import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tawasal/InitialProfileSettings.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneCtrl = TextEditingController();

  Widget _phoneNumberLabel() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        'Phone number',
        softWrap: true,
      ),
    );
  }

  Widget _phoneNumber() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: TextFormField(
        controller: _phoneCtrl,
        decoration:
            InputDecoration(border: null, labelText: 'Enter your phone number'),
        autofocus: true,
        validator: (value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Container(
                      child: LinearProgressIndicator(),
                    ),
                  );
                });
            // ignore: unused_local_variable
            var result = await _login()
                .whenComplete(() => Navigator.pop(context))
                .then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InitialProfileSettings())));
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+2' + _phoneCtrl.text,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            print(e.message);
          },
          codeSent: (String verificationId, int resendToken) async {
            String smsCode = '236545';
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: smsCode);
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      String msg = '';
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        msg = 'No user found for that email.';
      } else {
        print(e.code);
        msg = e.code;
      }
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Container(child: Text(msg)));
          });
    }
  }

  Widget _mainForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Column(
            children: [_phoneNumberLabel(), _phoneNumber(), _loginButton()],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainForm(),
    );
  }
}
