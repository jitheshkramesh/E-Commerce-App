import 'package:flutter/material.dart';
import '../components/product_details.dart';

class SingleProducts extends StatelessWidget {
  final prodImage;
  final prodId;
  final prodTitle;
  final prodDescription;
  final prodPrice;
  final prodOldPrice;
  final prodIsFavorite;
  final model;
  SingleProducts(
      {this.prodId,
      this.prodTitle,
      this.prodDescription,
      this.prodPrice,
      this.prodOldPrice,
      this.prodImage,
      this.prodIsFavorite,
      this.model});

  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: new Text(prodTitle),
        child: Material(
          child: InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new ProductDetails(
                      model: model,
                      productDetailsId: prodId,
                      productDetailsTitle: prodTitle,
                      productDetailsDescription: prodDescription,
                      productDetailsPrice: prodPrice,
                      productDetailsOldPrice: prodOldPrice,
                      productDetailsImage: prodImage,
                      productDetailsFavorite: prodIsFavorite,
                    ))),
            child: GridTile(
              footer: Container(
                color: Colors.white54,
                height: 60.0,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        prodTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    new Text("\$$prodPrice",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.red))
                  ],
                ),
              ),
              child: Image.network(
                prodImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
