import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/drawer_list.dart';
import '../scoped_model/main.dart';

import '../components/list_products.dart';
import '../notifications/wishlist_icon_counter.dart';
import '../notifications/cartlist_icon_counter.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;
  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductStatePage();
  }
}

class _ProductStatePage extends State<ProductsPage> {
  String imagePath;

  @override
  initState() {
    widget.model.fetchProducts();
    //widget.model.allProducts;
    print('Image path is :');
    print(widget.model.userRegister.imagePath);
    imagePath = widget.model.userRegister.imagePath.toString();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return DrawerList(widget.model);
  }

  Widget _buildProductList() {
    return ScopedModelDescendant(
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
        return RefreshIndicator(onRefresh: model.fetchProducts, child: content);
      },
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
              return WishListIconCounter(widget.model);
            },
          ),
          CartListIconCounter(widget.model),
        ],
      ),
      body: _buildProductList(),
      // body: new Column(
      //   children: <Widget>[

      //     Flexible(
      //       child: ListProducts(widget.model),
      //     )
      //   ],
      // ),
    );
  }
}
