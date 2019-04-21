import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../ui_elements/title_default.dart';
import '../../models/category.dart';
import '../../scoped_model/main.dart';

class CategoryCard extends StatelessWidget {
  final CategoryData category;

  CategoryCard(this.category);

  Widget _buildTitleCategoryRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: TitleDefault(category.catDesc),
          ),
          Flexible(
            child: SizedBox(
              width: 8.0,
            ),
          ),
          Flexible(
            child: TitleDefault(category.id.toString()),
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  model.selectCategory(category.id);
                  Navigator.pushNamed<bool>(
                          context, '/category/' + category.id)
                      .then((_) => model.selectCategory(null));
                },
              )
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //print('Category image is ${category.image}');
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: category.id,
            child: FadeInImage(
              image: NetworkImage(category.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/food.jpg'),
            ),
          ),
          _buildTitleCategoryRow(),
          SizedBox(
            height: 10.0,
          ),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
