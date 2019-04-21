import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/products/categories.dart';
import '../widgets/ui_elements/drawer_list.dart';
import '../scoped_model/main.dart';

class CategoriesPage extends StatefulWidget {
  final MainModel model;
  CategoriesPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CategoryStatePage();
  }
}

class _CategoryStatePage extends State<CategoriesPage> {

  @override
  initState() {
    //widget.model.fetchCategories();
    widget.model.fetchCategories(onlyforUser: true, clearExisting: true);
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return  DrawerList(widget.model);
  }

  Widget _buildCategoryList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Categories Found!'));
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = Categories();
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
        title: Text('Category'),
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
      body: _buildCategoryList(),
    );
  }
}
