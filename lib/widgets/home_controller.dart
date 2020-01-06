import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_liste_voeux/model/item.dart';
import 'package:flutter_liste_voeux/widgets/empty_data.dart';
import 'package:flutter_liste_voeux/model/databaseClient.dart';
import 'package:flutter_liste_voeux/widgets/itemDetails.dart';

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
              onPressed: (() => add(null)),
              child: Text(
                'Ajouter',
                style: TextStyle(color: Colors.white),
              )
          )
        ],
      ),
      body: (items == null || items.length == 0) ?
      EmptyData() : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          Item item = items[i];
          return ListTile(
            title: Text(item.name),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                DatabaseClient().delete(item.id, 'item').then((int) {
                  get();
                });
              },
            ),
            leading: IconButton(
              icon: Icon(Icons.edit),
              onPressed: (() => add(item)),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContext) {
                return ItemDetails(item);
              }));
            },
          );
        })
    );
  }

  Future add(Item item) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text("Ajouter une liste de souhaits"),
            content: TextField(
              decoration: InputDecoration(
                  labelText: 'Liste :',
                  hintText: (item == null) ? 'Ex : mes prochains jeux de société' : item.name,
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
                    if (item == null) {
                      Map<String, dynamic> map = { 'name': newList };
                      item = Item();
                      item.fromMap(map);
                    } else {
                      item.name = newList;
                    }
                    DatabaseClient().upsertItem(item).then((i) => get());
                    newList = null;
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
