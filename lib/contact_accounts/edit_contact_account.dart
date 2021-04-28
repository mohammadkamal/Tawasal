import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/contact_accounts/contacts_list.dart';

class EditContactAccount extends StatefulWidget {
  @override
  _EditContactAccountState createState() => _EditContactAccountState();
}

class _EditContactAccountState extends State<EditContactAccount> {
  String _displayName;
  final TextEditingController _nameCtrl = TextEditingController(text: FirebaseAuth.instance.currentUser.displayName);
  final _scaffoldStateKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser.displayName == null ||
        FirebaseAuth.instance.currentUser.displayName.isEmpty) {
      _displayName = FirebaseAuth.instance.currentUser.phoneNumber;
    } else {
      _displayName = FirebaseAuth.instance.currentUser.displayName;
    }
  }

  Widget _displayNameTile() {
    String _widgetName =
        FirebaseAuth.instance.currentUser.displayName.isEmpty ||
                FirebaseAuth.instance.currentUser.displayName == null
            ? 'No name specifed'
            : FirebaseAuth.instance.currentUser.displayName;
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Display name',
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text(_widgetName)
        ],
      ),
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _scaffoldStateKey.currentState
                .showBottomSheet((context) => _displayNameSheet());
          }),
    );
  }

  Widget _displayNameSheet() {
    return Form(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 5, bottom: 5),
            child: Text(
              'New display name',
              softWrap: true,
            ),
          ),
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 7))),
            controller: _nameCtrl,
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser
                    .updateProfile(displayName: _nameCtrl.text)
                    .then((value) => Navigator.pop(context));
                context.read<ContactsList>().updateDisplayName(
                    FirebaseAuth.instance.currentUser.uid, _nameCtrl.text);
              },
              child: Text('Update')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: AppBar(
        title: Text(_displayName),
      ),
      body: ListView(
        children: [_displayNameTile()],
      ),
    );
  }
}
