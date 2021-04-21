import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tawasal/ContactsList.dart';

class ViewContactsList extends StatefulWidget {
  @override
  _ViewContactsListState createState() => _ViewContactsListState();
}

class _ViewContactsListState extends State<ViewContactsList> {
  void initState() {
    super.initState();
    context.read<ContactsList>().fetchData();
  }

  Widget _callWaitingDialog() {
    return AlertDialog(
      content: ListView(
        shrinkWrap: true,
        children: [
          Row(
              children: [CircularProgressIndicator()],
              mainAxisAlignment: MainAxisAlignment.center),
          GestureDetector(
            child: Container(
              alignment: Alignment.bottomRight,
              child: Text('Cancel'),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
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
                        showDialog(context: context, builder: (context) =>_callWaitingDialog());
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
