import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_model/main.dart';
import '../widgets/ui_elements/drawer_list.dart';
import '../notifications/wishlist_icon_counter.dart';
import '../notifications/cartlist_icon_counter.dart';

class HomePage extends StatefulWidget {
  final MainModel model;
  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    print('Home page init starting..');
    widget.model.fetchCategories(onlyforUser: true, clearExisting: true);
    widget.model.fetchProducts(onlyforUser: true, clearExisting: true);
    print('Home page init started..');
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return DrawerList(widget.model);
  }

  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException(
            "*An error occurred when converting a color.");
      }
    }
    return val;
  }

  Future<Null> refreshIndicator() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      widget.model.fetchCategories(onlyforUser: true, clearExisting: true);
      widget.model.fetchProducts(onlyforUser: true, clearExisting: true);
      print('All Categories count is ${widget.model.allCategories.length}');
      print('All Products count is ${widget.model.allProducts.length}');
    });
    return null;
  }

  Widget _buildProductCategoryList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Products Found!'));
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        color: Color(getColorHexFromStr('#FDD148')),
                      ),
                      Positioned(
                        bottom: 100.0,
                        right: 200.0,
                        child: Container(
                          height: 300.0,
                          width: 300.00,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Color(getColorHexFromStr('#FE0000'))
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 200.0,
                        left: 300.0,
                        child: Container(
                          height: 200.0,
                          width: 200.00,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Color(getColorHexFromStr('#FE0000'))
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 15.0,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(95.0),
                                    border: Border.all(
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                        width: 2.0),
                                    image: DecorationImage(
                                      image: new NetworkImage((widget.model
                                                  .userRegister.imagePath ==
                                              null)
                                          ? 'assets/food.jpg'
                                          : widget
                                              .model.userRegister.imagePath),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Hello , ${widget.model.userRegister.firstName}',
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              'What do you want to buy ?',
                              style: TextStyle(
                                  fontSize: 23.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 25.0),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(5.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search,
                                        color: Color(
                                            getColorHexFromStr('#FDD148')),
                                        size: 30.0),
                                    contentPadding:
                                        EdgeInsets.only(left: 15.0, top: 15.0),
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      )
                    ],
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: new Text(
                      'Categories',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Material(
                        elevation: 1.0,
                        child: Container(
                          height: 75.0,
                          color: Colors.white,
                        ),
                      ),

                      // CategoryBanner(widget.model),

                      Container(
                        height: 120,
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
                      ),
                    ],
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: new Text(
                      'Recent Products',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  // new Scaffold(
                  //   appBar: AppBar(
                  //     title: new Text('Recent Products'),
                  //   ),
                  //   body: ListView.builder(
                  //     itemCount: widget.model.allProducts.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Container(
                  //         constraints: BoxConstraints.tightFor(height: 150.0),
                  //         child: Text(
                  //             'widget.model.allProducts[index].description'),
                  //       );
                  //     },
                  //   ),
                  // ),
                  //productGridList(context, model),
                  itemCard(
                      widget.model.allProducts[0].title,
                      widget.model.allProducts[0].description,
                      widget.model.allProducts[0].image,
                      widget.model.allProducts[0].price.toString(),
                      false),
                  itemCard(
                      widget.model.allProducts[1].title,
                      widget.model.allProducts[1].description,
                      widget.model.allProducts[1].image,
                      widget.model.allProducts[1].price.toString(),
                      true),
                  itemCard(
                      widget.model.allProducts[2].title,
                      widget.model.allProducts[2].description,
                      widget.model.allProducts[2].image,
                      widget.model.allProducts[2].price.toString(),
                      false),
                  itemCard(
                      widget.model.allProducts[3].title,
                      widget.model.allProducts[3].description,
                      widget.model.allProducts[3].image,
                      widget.model.allProducts[3].price.toString(),
                      false),
                  //itemCard(widget.model.allProducts[3].title, 'assets/food.jpg', false),
                ],
              )
            ],
          );
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: refreshIndicator, child: content);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('E-Commerce Home Page'),
        actions: <Widget>[
          // new IconButton(
          //   icon: Icon(Icons.favorite),
          //   onPressed: () {
          //     Navigator.pushReplacementNamed(context, '/wishedList');
          //   },
          // ),
          WishListIconCounter(widget.model),
          CartListIconCounter(widget.model),
          // new IconButton(
          //   icon: Icon(Icons.shopping_cart),
          //   onPressed: () {
          //     Navigator.push(
          //         context, MaterialPageRoute(builder: (context) => new Cart()));
          //   },
          // ),
        ],
      ),
      body: _buildProductCategoryList(),
      key: refreshKey,
    );
  }

  Widget itemRow(String title, bool isFavorite) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 45.0),
        Material(
          elevation: isFavorite ? 0.0 : 2.0,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color:
                    isFavorite ? Colors.grey.withOpacity(0.2) : Colors.white),
            child: Center(
              child: isFavorite
                  ? Icon(Icons.favorite_border)
                  : Icon(Icons.favorite, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemColumn(
      String title, bool isFavorite, String description, String price) {
    return Column(
      children: <Widget>[
        itemRow(title, isFavorite),
        SizedBox(
          height: 5.0,
        ),
        Container(
          width: 300.0,
          child: Text(
            description.length > 100
                ? description.substring(1, 100)
                : description,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              color: Color(getColorHexFromStr('#9400D3')),
              child: Center(
                child: Text(
                  '\$${price.toString()}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 40.0,
              width: 120.0,
              color: Color(getColorHexFromStr('#FDD148')),
              child: new RaisedButton(
                child: new Text(
                  'Add To Cart',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                colorBrightness: Brightness.light,
                onPressed: () {
                  print('You selected product is $title');
                },
              ),
            )
          ],
        )
      ],
    );
  }

  Widget itemCard(String title, String description, String imgPath,
      String price, bool isFavorite) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Container(
        height: 150.0,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              width: 140.0,
              height: 150.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(imgPath), //network(imgPath),
                fit: BoxFit.cover,
              )),
            ),
            SizedBox(
              width: 4.0,
            ),
            itemColumn(title, isFavorite, description, price),
          ],
        ),
      ),
    );
  }

  Widget productGridList(BuildContext context, MainModel model) {
    return GridView.builder(
        itemCount: model.allProducts.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return singleProd(
            prodDescription: model.allProducts[index].description,
            prodPrice: model.allProducts[index].price,
            prodImage: model.allProducts[index].image,
            prodIsFavorite: model.allProducts[index].isFavorite,
          );
        });
  }
}

class singleProd extends StatelessWidget {
  final prodImage;
  final prodDescription;
  final prodPrice;
  final prodIsFavorite;
  singleProd(
      {this.prodDescription,
      this.prodPrice,
      this.prodImage,
      this.prodIsFavorite});
  Widget build(BuildContext context) {
    return Container(child: Text("Testing.."));
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
        width: 150.0,
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
