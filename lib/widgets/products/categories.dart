import 'package:flutter/material.dart';
import './categories_card.dart';
import '../../models/category.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_model/main.dart';

class Categories extends StatelessWidget {
  Widget _buildCategoryList(List<CategoryData> categories) {
    Widget categoryCards;
    if (categories.length > 0) {
      categoryCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            CategoryCard(categories[index]),
        itemCount: categories.length,
      );
    } else {
      categoryCards = Container();
    }
    return categoryCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildCategoryList(model.displayedCategories);
      },
    );
  }
}
