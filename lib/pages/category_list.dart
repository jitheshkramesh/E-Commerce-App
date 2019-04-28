import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../pages/category_edit.dart';
import '../scoped_model/main.dart';

class CategoryListPage extends StatefulWidget {
  final MainModel model;

  CategoryListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CategoryistPageState();
  }
}

class _CategoryistPageState extends State<CategoryListPage> {
  @override
  initState() {
    widget.model.fetchCategories(onlyforUser: true, clearExisting: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectCategory(model.allCategories[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return CategoryEditPage(model);
            },
          ),
        ).then((_) {
          model.selectCategory(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(model.allCategories[index].id),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                model.selectCategory(model.allCategories[index].id);
                //model.deleteProduct();
                Scaffold.of(context).showSnackBar(
                    new SnackBar(content: new Text('Item dismissed')));
                print('Swiped end to start');
              } else if (direction == DismissDirection.startToEnd) {
                print('Swiped start to end');
              } else {
                print('Other swipping');
              }
            },
            background: Container(color: Colors.red),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(model.allCategories[index].image),
                  ),
                  title: Text(model.allCategories[index].catDesc),
                  // subtitle:
                  //     Text('${model.allCategories[index].id.toString()}'),
                  trailing: _buildEditButton(context, index, model),
                ),
                Divider()
              ],
            ),
          );
        },
        itemCount: model.allCategories.length,
      );
    });
  }
}
