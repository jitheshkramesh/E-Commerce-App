import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/products/products.dart';
import '../widgets/ui_elements/drawer_list.dart';
import '../scoped_model/main.dart';

class WishedListPage extends StatefulWidget {
  final MainModel model;
  WishedListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _WishedListStatePage();
  }
}

class _WishedListStatePage extends State<WishedListPage> {
  String imagePath;

  @override
  initState() {
    widget.model.fetchProducts();
    print('Image path is :');
    print(widget.model.userRegister.imagePath);
    imagePath = widget.model.userRegister.imagePath.toString();
    widget.model.toggleDisplayMode();
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
          content = Products();
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
        title: Text('Wished List'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: _buildProductList(),
    );
  }
}
