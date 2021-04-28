import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/contact_accounts/contacts_list.dart';

class ViewContactsList extends StatefulWidget {
  @override
  _ViewContactsListState createState() => _ViewContactsListState();
}

class _ViewContactsListState extends State<ViewContactsList> {
  void initState() {
    super.initState();
    context.read<ContactsList>().fetchData();
  }

  Widget _callWaitingDialog(String _name) {
    return AlertDialog(
      title: Text('Calling...'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
            Text('Calling ' + _name)
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel'))
      ],
    );
  }

  Widget _contactsListView() {
    return ListView(
        children: Provider.of<ContactsList>(context).contactsMap.isNotEmpty
            ? Provider.of<ContactsList>(context).contactsMap.keys.map((e) {
                return ListTile(
                  title: Text(Provider.of<ContactsList>(context)
                      .contactsMap[e]
                      .displayName),
                  subtitle: Text(Provider.of<ContactsList>(context)
                      .contactsMap[e]
                      .phoneNumberInternational),
                  trailing: IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => _callWaitingDialog(
                                Provider.of<ContactsList>(context)
                                    .contactsMap[e]
                                    .displayName));
                      }),
                );
              }).toList()
            : []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Available Contatcs'),
        ),
        body: _contactsListView());
  }
}
