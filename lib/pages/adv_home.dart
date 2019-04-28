import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import '../scoped_model/main.dart';
import '../widgets/ui_elements/drawer_list.dart';
import '../components/horizontal_listview.dart';
import '../components/list_products.dart';
import '../components/cart.dart';
import '../notifications/wishlist_icon_counter.dart';

class AdvHomePage extends StatefulWidget {
  final MainModel model;
  AdvHomePage(this.model);

  @override
  _AdvHomePageState createState() => _AdvHomePageState();
}

class _AdvHomePageState extends State<AdvHomePage> {
  @override
  Widget build(BuildContext context) {
    Widget imageCarousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/bannerImages/1.jpg'),
          AssetImage('assets/bannerImages/2.jpg'),
          AssetImage('assets/bannerImages/3.png'),
          AssetImage('assets/bannerImages/4.jpg'),
          AssetImage('assets/bannerImages/5.jpg'),
          AssetImage('assets/bannerImages/6.jpg'),
          AssetImage('assets/bannerImages/7.jpg'),
        ],
        autoplay: false,
        // animationCurve: Curves.fastOutSlowIn,
        // animationDuration: Duration(milliseconds: 1000 )
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );
    return Scaffold(
      drawer: DrawerList(widget.model),
      appBar: new AppBar(
        elevation: 0.1,
        title: new Text('Home Page'),
        actions: <Widget>[
          WishListIconCounter(widget.model),
          // new IconButton(
          //   icon: Icon(Icons.favorite),
          //   onPressed: () {
          //     Navigator.pushReplacementNamed(context, '/wishedList');
          //   },
          // ),
          new IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => new Cart(widget.model)));
            },
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          imageCarousel,
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          HorizontalListView(widget.model),
          new Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Text(
              'Recent Products',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Flexible(
            child: ListProducts(widget.model),
          )
        ],
      ),
    );
  }
}
