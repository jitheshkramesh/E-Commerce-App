import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_pro/carousel_pro.dart';

import '../widgets/ui_elements/drawer_list.dart';
import '../scoped_model/main.dart';
import '../components/cart.dart';
import '../components/list_products.dart';

class CatProductsPage extends StatefulWidget {
  final MainModel model;
  final catId;
  final catImage;
  final catDescription;
  CatProductsPage({this.model, this.catId, this.catImage, this.catDescription});

  @override
  State<StatefulWidget> createState() {
    return _CatProductStatePage();
  }
}

class _CatProductStatePage extends State<CatProductsPage> {
  String imagePath;

  @override
  initState() {
    widget.model.fetchProducts(catfilter: widget.catId);
    //widget.model.allProducts;
    print('Image path is :');
    print('Category id is :${widget.catId}');
    print('Product count is : ${widget.model.allProducts.length}');
    print(widget.model.userRegister.imagePath);
    imagePath = widget.model.userRegister.imagePath.toString();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return DrawerList(widget.model);
  }

  Widget _buildProductList() {
    return Container(
      //height: 300.0,
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          Widget content = Center(child: Text('No Products Found!'));
          if (model.displayedProducts.length > 0 && !model.isLoading) {
            //content = Products();
            content = new Column(
              children: <Widget>[
                Flexible(
                  child: ListProducts(widget.model),
                )
              ],
            );
          } else if (model.isLoading) {
            content = Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
              onRefresh: model.fetchProducts, child: content);
        },
      ),
    );
  }

  Widget catBanner() {
    return Image.network(
      widget.catImage,
      height: 150.0,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('E-Commerce'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/wishedList');
                },
              );
            },
          ),
          new IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new Cart(widget.model)));
            },
          ),
        ],
      ),
      body: new Container(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              widget.catDescription,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            new Image.network(
              widget.catImage,
              fit: BoxFit.cover,
              height: 150.0,
            ),
            new Text(
              "Products :",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            new Container(
              height: 2.0,
              width: 150.0,
              color: Colors.redAccent,
            ),
            new Flexible(
              child: _buildProductList(),
            )
            //new Container()
          ],
        ),
      ),
    );
  }
}
