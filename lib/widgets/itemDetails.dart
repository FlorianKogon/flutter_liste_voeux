import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_liste_voeux/model/item.dart';
import 'package:flutter_liste_voeux/model/article.dart';
import 'package:flutter_liste_voeux/widgets/add_article.dart';
import 'package:flutter_liste_voeux/widgets/empty_data.dart';
import 'package:flutter_liste_voeux/model/databaseClient.dart';

class ItemDetails extends StatefulWidget {

  Item item;

  ItemDetails(this.item);
  @override
  _ItemDetailsState createState() => _ItemDetailsState();

}

class _ItemDetailsState extends State<ItemDetails> {

  List<Article> articles;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContext){
                return AddArticle(widget.item.id, widget.item.name);
              })).then((value) {
                DatabaseClient().allArticles(widget.item.id).then((liste) {
                  setState(() {
                    articles = liste;
                  });
                });
              });
            },
            child: Text('Ajouter',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
      body: (articles == null || articles.length == 0) ?
          EmptyData() : GridView.builder(itemCount: articles.length, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1), itemBuilder: (context, i) {
            Article article = articles[i];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(article.name),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                      child: (article.image == null) ? Image.asset('images/no_image.jpg') : Image.file(File(article.image)),
                  ),
                  Text((article.price == null) ? 'Aucun prix renseigné': "Prix : ${article.price}"),
                  Text((article.store == null) ? 'Aucun magasin renseigné': "Magasin : ${article.store}"),
                ],
              ),
            );
      })
    );
  }

}