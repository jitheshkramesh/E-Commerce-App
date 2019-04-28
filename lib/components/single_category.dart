import 'package:flutter/material.dart';
import 'cat_products.dart';

class SingleCategory extends StatelessWidget {
  final catImage;
  final catId;

  final catDescription;

  final model;
  SingleCategory({this.catId, this.catDescription, this.catImage, this.model});

  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: new Text(catDescription),
        child: Material(
          child: InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new Column(
                      children: <Widget>[
                        Flexible(
                          child: CatProductsPage(
                            model: this.model,
                            catId: catId.toString(),
                            catImage: this.catImage,
                            catDescription: this.catDescription,
                          ),
                        )
                      ],
                    ))),
            child: GridTile(
              footer: Container(
                color: Colors.white54,
                height: 60.0,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        catDescription,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    )
                  ],
                ),
              ),
              child: Image.network(
                catImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
