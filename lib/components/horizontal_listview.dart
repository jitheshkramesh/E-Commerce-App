import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_model/main.dart';

class HorizontalListView extends StatefulWidget {
  final MainModel model;
  HorizontalListView(this.model);
  @override
  State<StatefulWidget> createState() {
    return _HorizontalListViewState();
  }
}

class _HorizontalListViewState extends State<HorizontalListView> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    print('Home page init starting..');
    widget.model.fetchCategories(onlyforUser: true, clearExisting: true);
    print('Home page init started..');
    super.initState();
  }

  Future<Null> refreshIndicator() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      widget.model.fetchCategories(onlyforUser: true, clearExisting: true);
      print('All Categories count is ${widget.model.allCategories.length}');
      print('All Products count is ${widget.model.allProducts.length}');
    });
    return null;
  }

  static const kListHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No Categories Found!'));
      if (model.displayedCategories.length > 0 && !model.isLoading) {
        content = Container(
          height: kListHeight,
          // child: new ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     shrinkWrap: true,
          //     itemCount: model.displayedCategories.length,
          //     padding: new EdgeInsets.symmetric(vertical: 16.0),
          //     itemBuilder: (BuildContext context, int index) {
          //       return ListView(
          //         scrollDirection: Axis.horizontal,
          //         children: <Widget>[
          //           CategoryList(
          //             imageCaption: model.displayedCategories[index].catDesc,
          //             imageLocation: model.displayedCategories[index].image,
          //           ),
          //         ],
          //       );
          //     }),
            child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            // _MyCategoryListView(widget.model.allCategories[0].catDesc, widget.model.allCategories[0].image),
                            _MyCategoryListView(
                                widget.model.allCategories[1].catDesc,
                                widget.model.allCategories[1].image),
                            _MyCategoryListView(
                                widget.model.allCategories[2].catDesc,
                                widget.model.allCategories[2].image),
                            _MyCategoryListView(
                                widget.model.allCategories[3].catDesc,
                                widget.model.allCategories[3].image),
                            _MyCategoryListView(
                                widget.model.allCategories[4].catDesc,
                                widget.model.allCategories[4].image),
                            _MyCategoryListView(
                                widget.model.allCategories[5].catDesc,
                                widget.model.allCategories[5].image),
                            _MyCategoryListView(
                                widget.model.allCategories[6].catDesc,
                                widget.model.allCategories[6].image),
                            _MyCategoryListView(
                                widget.model.allCategories[7].catDesc,
                                widget.model.allCategories[7].image),
                            _MyCategoryListView(
                                widget.model.allCategories[8].catDesc,
                                widget.model.allCategories[8].image),
                            _MyCategoryListView(
                                widget.model.allCategories[9].catDesc,
                                widget.model.allCategories[9].image),
                          ],
                        ),
        );
      } else if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(onRefresh: refreshIndicator, child: content);
    });
  }
}

class CategoryList extends StatelessWidget {
  final String imageLocation;
  final String imageCaption;
  CategoryList({this.imageCaption, this.imageLocation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 100.0,
          child: ListTile(
            title: Image.network(
              imageLocation,
              width: 100.0,
              height: 40.0,
            ),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(imageCaption),
            ),
          ),
        ),
      ),
    );
  }
}

class _MyCategoryListView extends StatelessWidget {
  final String title;
  final String imgPath;
  _MyCategoryListView(this.title, this.imgPath);
  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        width: 120.0,
        child: InkWell(
          onTap: () {
            print('Category banner selected. $title');
          },
          child: ListTile(
            title: Image.network(
              this.imgPath,
              width: 100.0,
              height: 50.0,
            ),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(
                this.title,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    } catch (error) {
      print('Error found in _MyCategoryListView.');
      return null;
    }
  }
}
