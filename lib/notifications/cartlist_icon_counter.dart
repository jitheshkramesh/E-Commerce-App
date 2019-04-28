import 'package:flutter/material.dart';
import '../scoped_model/main.dart';
import '../components/cart.dart';

class CartListIconCounter extends StatelessWidget {
  final MainModel model;

  CartListIconCounter(this.model);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Stack(children: <Widget>[
        new Icon(
          Icons.shopping_cart,
          size: 26.0,
        ),
        new Positioned(
            top: -1.0,
            right: -1.0,
            child: new Stack(
              children: <Widget>[
                new Text(
                  model.displayedCartProducts.length.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
              ],
            ))
      ]),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new Cart(model)));
      },
    );
  }
}
