import 'package:flutter/material.dart';
import './product_edit.dart';
import './product_list.dart';
import '../scoped_model/main.dart';
import '../widgets/ui_elements/drawer_list.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    print('Image path is :');
    print(model.userRegister.imagePath);
    return DrawerList(model);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: _buildSideDrawer(context),
          appBar: AppBar(
              title: Text('Manage Products'),
              elevation:
                  Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.create),
                    text: 'Create Product',
                  ),
                  Tab(
                    icon: Icon(Icons.list),
                    text: 'My Products',
                  )
                ],
              )),
          body: TabBarView(
            children: <Widget>[ProductEditPage(model), ProductListPage(model)],
          )),
    );
  }
}
