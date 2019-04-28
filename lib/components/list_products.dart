import 'package:flutter/material.dart';
import '../scoped_model/main.dart';
//import '../components/product_details.dart';
import '../components/single_products.dart';

class ListProducts extends StatefulWidget {
  final MainModel model;
  ListProducts(this.model);
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.model.allProducts.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SingleProducts(
            prodTitle: widget.model.allProducts[index].title,
            prodId: widget.model.allProducts[index].id,
            prodDescription: widget.model.allProducts[index].description,
            prodIsFavorite: widget.model.allProducts[index].isFavorite,
            prodPrice: widget.model.allProducts[index].price,
            prodOldPrice: widget.model.allProducts[index].price - 10,
            prodImage: widget.model.allProducts[index].image,
            model: widget.model,
          ),
        );
      },
    );
  }
}
