import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/contact_accounts/contact_account.dart';
import 'package:tawasal/contact_accounts/contacts_list.dart';
import 'package:tawasal/rooms_list.dart';

class InitialProfileSettings extends StatefulWidget {
  @override
  _InitialProfileSettingsState createState() => _InitialProfileSettingsState();
}

class _InitialProfileSettingsState extends State<InitialProfileSettings> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  ContactAccount _contactAccount;
  String _phoneNumberInter;
  String _phoneNumberLocal;

  Widget _displayNameLabel() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        'Your Name:',
        softWrap: true,
      ),
    );
  }

  Widget _displayName() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: TextFormField(
        controller: _nameCtrl,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(width: 7)),
            labelText: 'Enter your name'),
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

  Widget _confirmButton() {
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
            var result = await _confirmData()
                .whenComplete(() => Navigator.pop(context))
                .then((value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomsList(),
                    )));
          }
        },
        child: Text('Confirm'),
      ),
    );
  }

  Future<void> _confirmData() async {
    _phoneNumberInter = FirebaseAuth.instance.currentUser.phoneNumber;
    _phoneNumberLocal = _phoneNumberInter.substring(2);
    _contactAccount = ContactAccount(
        phoneNumberInternational: _phoneNumberInter,
        phoneNumberLocal: int.tryParse(_phoneNumberLocal),
        displayName: _nameCtrl.text);
    await FirebaseAuth.instance.currentUser
        .updateProfile(displayName: _nameCtrl.text);
    context
        .read<ContactsList>()
        .addNewContact(FirebaseAuth.instance.currentUser.uid, _contactAccount);
  }

  Widget _mainForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Column(
            children: [_displayNameLabel(), _displayName(), _confirmButton()],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _mainForm(),
    );
  }
}
