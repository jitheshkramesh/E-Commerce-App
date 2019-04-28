import 'package:flutter/material.dart';

class CartProducts extends StatefulWidget {
  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  var productsOnCart = [
    {
      "prod_id": "1",
      "prod_title": "Shirt",
      "prod_description": "Cotton Shirt",
      "prod_price": 17.0,
      "prod_image": "assets/food.jpg",
      "prod_size": "40",
      "prod_color": "Blue",
      "prod_qty": "1",
    },
    {
      "prod_id": "2",
      "prod_title": "Trouser",
      "prod_description": "Cotton Trouser",
      "prod_price": 22.0,
      "prod_image": "assets/food.jpg",
      "prod_size": "32",
      "prod_color": "Black",
      "prod_qty": "1",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: productsOnCart.length,
      itemBuilder: (context, index) {
        return SingleCartProduct(
          cartprodId: productsOnCart[index]["prod_id"],
          cartprodTitle: productsOnCart[index]["prod_title"],
          cartprodDescription: productsOnCart[index]["prod_description"],
          cartprodImage: productsOnCart[index]["prod_image"],
          cartprodColor: productsOnCart[index]["prod_color"],
          cartprodPrice: productsOnCart[index]["prod_price"],
          cartprodQty: productsOnCart[index]["prod_qty"],
          cartprodSize: productsOnCart[index]["prod_size"],
        );
      },
    );
  }
}

class SingleCartProduct extends StatelessWidget {
  final cartprodId;
  final cartprodTitle;
  final cartprodDescription;
  final cartprodPrice;
  final cartprodImage;
  final cartprodSize;
  final cartprodColor;
  final cartprodQty;

  SingleCartProduct(
      {this.cartprodId,
      this.cartprodTitle,
      this.cartprodDescription,
      this.cartprodImage,
      this.cartprodColor,
      this.cartprodSize,
      this.cartprodQty,
      this.cartprodPrice});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: new Image.asset(
          cartprodImage,
          width: 80.0,
          height: 80.0,
        ),
        //title: new Text(cartprodTitle),
        subtitle: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Text(cartprodTitle),
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text("Size:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(
                    cartprodSize,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                  child: new Text("Color:"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(
                    cartprodColor,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            new Container(
              alignment: Alignment.topLeft,
              child: new Text(
                "\$$cartprodPrice",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            )
          ],
        ),
        trailing: new Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 18.0, 4.0, 0.0),
              child: new IconButton(
                icon: Icon(Icons.arrow_drop_up),
                onPressed: () {},
              ),
            ),
            new Text("$cartprodQty"),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
              child: new IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
