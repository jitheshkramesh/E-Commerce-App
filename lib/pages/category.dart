import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/ui_elements/title_default.dart';
import '../widgets/products/category_fab.dart';
import '../models/category.dart';

class CategoryPage extends StatelessWidget {
  final CategoryData category;
  CategoryPage(this.category);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(product.title),
        // ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(category.catDesc),
                background: Hero(
                  tag: category.id,
                  child: FadeInImage(
                    image: NetworkImage(category.image),
                    height: 300.0,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/background.jpg'),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: TitleDefault(category.catDesc),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(10.0),
                  //   child: RaisedButton(
                  //     color: Theme.of(context).accentColor,
                  //     child: Text('INACTIVE'),
                  //     onPressed: () => _showWarningDialog(context),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: CategoryFab(category),
      ),
    );
  }
}
