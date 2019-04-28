import 'package:flutter/material.dart';
import '../scoped_model/main.dart';
import '../components/single_category.dart';

class ListCategories extends StatefulWidget {
  final MainModel model;
  ListCategories(this.model);
  _ListCategoriesState createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.model.allCategories.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SingleCategory(
            catId: widget.model.allCategories[index].id,
            catDescription: widget.model.allCategories[index].catDesc,
            catImage: widget.model.allCategories[index].image,
            model: widget.model,
          ),
        );
      },
    );
  }
}
