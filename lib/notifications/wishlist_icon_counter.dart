import 'package:flutter/material.dart';
import '../scoped_model/main.dart';

class WishListIconCounter extends StatelessWidget {
  final MainModel model;

  WishListIconCounter(this.model);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Stack(children: <Widget>[
        new Icon(
          Icons.favorite,
          size: 26.0,
        ),
        new Positioned(
            top: -1.0,
            right: -1.0,
            child: new Stack(
              children: <Widget>[
                new Text(
                  model.displayedProducts.length.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
              ],
            ))
      ]),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/wishedList');
      },
    );
  }
}
