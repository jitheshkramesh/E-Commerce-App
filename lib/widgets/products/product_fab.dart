import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../scoped_model/main.dart';
import '../../models/product.dart';

import '../ui_elements/drawer_list.dart';
import '../../notifications/wishlist_icon_counter.dart';
import '../../notifications/cartlist_icon_counter.dart';

class ProductFab extends StatefulWidget {
  final MainModel model;
  final Product product;

  ProductFab(this.product, this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return DrawerList(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('E-Commerce Home Page'),
        actions: <Widget>[
         WishListIconCounter(widget.model),
          CartListIconCounter(widget.model),
        ],
      ),
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                      parent: _controller,
                      curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).cardColor,
                    heroTag: 'contact',
                    mini: true,
                    onPressed: () async {
                      final url = 'mailto:${widget.product.userEmail}';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch';
                      }
                    },
                    child: Icon(
                      Icons.mail,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                      parent: _controller,
                      curve: Interval(0.0, 0.5, curve: Curves.easeOut)),
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).cardColor,
                    heroTag: 'favorite',
                    mini: true,
                    onPressed: () {
                      model.toggleProductFavoriteStatus();
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Container(
                height: 70.0,
                width: 56.0,
                child: FloatingActionButton(
                  heroTag: 'options',
                  onPressed: () {
                    if (_controller.isDismissed) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  },
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        alignment: FractionalOffset.center,
                        transform: Matrix4.rotationZ(
                            _controller.value * 0.5 * math.pi),
                        child: Icon(_controller.isDismissed
                            ? Icons.more_vert
                            : Icons.close),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
