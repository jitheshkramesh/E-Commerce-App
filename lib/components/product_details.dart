import 'package:flutter/material.dart';
//import '../widgets/ui_elements/drawer_list.dart';
import '../scoped_model/main.dart';
import '../pages/adv_home.dart';
//import '../components/list_products.dart';
import '../components/single_products.dart';
import '../components/cart.dart';
import '../notifications/cartlist_icon_counter.dart';
import '../notifications/wishlist_icon_counter.dart';

class ProductDetails extends StatefulWidget {
  final MainModel model;
  final productDetailsId;
  final productDetailsTitle;
  final productDetailsDescription;
  final productDetailsPrice;
  final productDetailsOldPrice;
  final productDetailsImage;
  final productDetailsFavorite;
  final productDetailsCart;

  ProductDetails(
      {this.model,
      this.productDetailsId,
      this.productDetailsTitle,
      this.productDetailsDescription,
      this.productDetailsPrice,
      this.productDetailsOldPrice,
      this.productDetailsImage,
      this.productDetailsFavorite,
      this.productDetailsCart});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextEditController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: DrawerList(widget.model),
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new AdvHomePage(widget.model)));
            },
            child: Text('E-Commerce')),
        actions: <Widget>[
          WishListIconCounter(widget.model),
          CartListIconCounter(widget.model),
          // new IconButton(
          //   icon: Icon(Icons.shopping_cart),
          //   onPressed: () {
          //     Navigator.push(
          //         context, MaterialPageRoute(builder: (context) => new Cart()));
          //   },
          // ),
          // new IconButton(
          //   icon: Icon(Icons.favorite),
          //   onPressed: () {
          //     Navigator.pushReplacementNamed(context, '/wishedList');
          //   },
          // )
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.network(
                  widget.productDetailsImage,
                  fit: BoxFit.cover,
                ),
              ),
              footer: new Container(
                color: Colors.white,
                child: ListTile(
                  leading: new Text(
                    widget.productDetailsTitle,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text(
                          "\$${widget.productDetailsOldPrice}",
                          style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      Expanded(
                        child: new Text("\$${widget.productDetailsPrice}",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              //first button

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _quantityTextEditController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Quantity'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You must enter the quantity';
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              //first button
              Expanded(
                child: MaterialButton(
                    onPressed: () {},
                    color: Colors.red,
                    textColor: Colors.white,
                    elevation: 0.2,
                    child: new Text('Buy Now')),
              ),
              //WishListIconCounter(widget.model),
              //CartListIconCounter(widget.model),

              new IconButton(
                icon: Icon(Icons.favorite),
                color: Colors.red,
                onPressed: () {
                  print('Favorites added');
                  widget.model.selectProduct(widget.productDetailsId);
                  widget.model.toggleProductFavoriteStatus();
                },
              ),
              new IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => new Cart()));
                  widget.model.selectProduct(widget.productDetailsId);
                  widget.model.toggleProductCartStatus();
                },
              ),
            ],
          ),
          Divider(
            color: Colors.red,
          ),
          new ListTile(
            title: new Text("Product details"),
            subtitle: new Text(widget.productDetailsDescription),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product Name",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product Brand",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product Condition",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Similar Products"),
          ),
          Container(
            height: 360.0,
            child: SimilarProducts(widget.model),
          )
        ],
      ),
    );
  }
}

class SimilarProducts extends StatefulWidget {
  final MainModel model;
  SimilarProducts(this.model);
  @override
  _SimilarProductsState createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.model.allProducts.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return SingleProducts(
          prodTitle: widget.model.allProducts[index].title,
          prodId: widget.model.allProducts[index].id,
          prodDescription: widget.model.allProducts[index].description,
          prodIsFavorite: widget.model.allProducts[index].isFavorite,
          prodPrice: widget.model.allProducts[index].price,
          prodOldPrice: widget.model.allProducts[index].price - 10,
          prodImage: widget.model.allProducts[index].image,
          model: widget.model,
        );
      },
    );
  }
}
