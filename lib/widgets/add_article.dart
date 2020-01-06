import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_liste_voeux/model/databaseClient.dart';
import 'package:flutter_liste_voeux/model/article.dart';
import 'package:image_picker/image_picker.dart';

class AddArticle extends StatefulWidget {

  int id;
  String name;

  AddArticle(this.id, this.name);

  @override
  _AddArticleState createState() => _AddArticleState();

}

class _AddArticleState extends State<AddArticle> {

  String image;
  String name;
  String store;
  String price;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: <Widget>[
          FlatButton(
            onPressed: add,
            child: Text('Valider',
            style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget> [
            Text(
              'Article à ajouter',
              textAlign: TextAlign.justify,
              textScaleFactor: 1.4,
              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
            ),
            Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  (image == null) ? Image.asset('images/no_image.jpg') : Image.file(File(image)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.camera_enhance), onPressed: () => getImage(ImageSource.camera)),
                      IconButton(icon: Icon(Icons.photo_library), onPressed: () => getImage(ImageSource.gallery)),
                    ],
                  ),
                  textField(TypeTextField.name, "Nom de l'article"),
                  textField(TypeTextField.price, "Prix"),
                  textField(TypeTextField.store, "Magasin")
                ],
              ),
            )
          ],
        ),
      )
    );
  }
  TextField textField(TypeTextField type, String label) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: (String string) {
        switch (type) {
          case TypeTextField.name:
            name = string;
            break;
          case TypeTextField.price:
            price = string;
            break;
          case TypeTextField.store:
            store = string;
            break;
        }
      },
    );
  }

  void add() {
    if (name != null) {
      Map<String, dynamic> map = { "name": name, "item": widget.id};
      if (store != null) {
        map['store'] = store;
      }
      if (price != null) {
        map['price'] = price;
      }
      if (image != null) {
        map['image'] = image;
      }
      Article article = Article();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value) {
        image = null;
        name = null;
        store = null;
        price = null;
        Navigator.pop(context);
      });
    }
  }

  Future getImage(ImageSource source) async {
    var newImage = await ImagePicker.pickImage(source: source);
    setState(() {
      image = newImage.path;
    });
  }

}

enum TypeTextField { name, price, store }