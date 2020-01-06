import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_liste_voeux/model/item.dart';
import 'package:flutter_liste_voeux/widgets/empty_data.dart';
import 'package:flutter_liste_voeux/model/databaseClient.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  String newList;
  List<Item> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
              onPressed: add,
              child: Text(
                'Ajouter',
                style: TextStyle(color: Colors.white),
              )
          )
        ],
      ),
      body: (items == null || items.length == 0) ?
      EmptyData() : ListView.builder(
          itemBuilder: (context, i) {
            Item item = items[i];
            return ListTile(
              title: Text(item.name),
            );
          })
    );
  }

  Future add() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text("Ajouter une liste de souhaits"),
            content: TextField(
              decoration: InputDecoration(
                  labelText: 'Liste :',
                  hintText: 'Ex : mes prochains jeux de société'
              ),
              onChanged: (String str) {
                newList = str;
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: (() => Navigator.pop(buildContext)),
                child: Text('Annuler'
                ),
              ),
              FlatButton(
                onPressed:  (() {
                  if (newList != null) {
                    Map<String, dynamic> map = { 'name': newList};
                    Item item = Item();
                    item.fromMap(map);
                    DatabaseClient().addItem(item).then((i) => get());
                    Navigator.pop(buildContext);
                  }
                }),
                child: Text('Valider'
                ),
              ),
            ],
          );
        }
    );
  }

  void get() {
    DatabaseClient().allItems().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }

}
