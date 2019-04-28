import 'package:flutter/material.dart';
import './cart_products.dart';
import '../notifications/wishlist_icon_counter.dart';
import '../notifications/cartlist_icon_counter.dart';
import '../scoped_model/main.dart';

class Cart extends StatefulWidget {
  final MainModel model;
  Cart(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: new Text('E-Commerce Cart'),
        actions: <Widget>[
          // WishListIconCounter(widget.model),
          //CartListIconCounter(widget.model),
          new IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/wishedList');
            },
          ),
          new IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              print('Shopping cart cart button clicked.');
            },
          ),
        ],
      ),
      body: new CartProducts(),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: new Text("Total :"),
                subtitle: new Text(
                  "\$236.0",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ),
            Expanded(
              child: new MaterialButton(
                onPressed: () {},
                child: new Text(
                  "Check Out",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
