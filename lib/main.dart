import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './pages/auth.dart';
import './pages/wished_list.dart';
import './pages/categories.dart';
import './pages/category.dart';
import './pages/category_admin.dart';

import './scoped_model/main.dart';

import './models/product.dart';
import './models/category.dart';

import './widgets/helpers/custome_route.dart';

import './shared/global_config.dart';
import './shared/adaptive_theme.dart';
//import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled=true;
  // debugPaintBaselinesEnabled=true;
  // debugPaintPointersEnabled=true;
  //map view commented
  MapView.setApiKey(apiKey);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  final _platformChannel = MethodChannel('E-CommerceApp.com/battery');
  bool _isAuthenticated = false;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _platformChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery Level is $result %.';
    } catch (error) {
      batteryLevel = 'Failed to get Battery Level.';
      print(error);
    }
    print(batteryLevel);
  }

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    //_getBatteryLevel();
    super.initState();

    _messaging.getToken().then((token) {
      print('Message token : $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build main page');
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'ECommApp',
        theme: getAdaptiveThemeData(context),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          // ScopedModelDescendant(
          //   builder: (BuildContext context, Widget child, MainModel model) {
          //     return model.user == null ? AuthPage() : ProductsPage(_model);
          //   },
          // ),
          //'/products': (BuildContext context) => ProductsPage(_model),
          '/admin': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model),
          '/wishedList': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : WishedListPage(_model),
          '/category': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : CategoriesPage(_model),
          '/catadmin': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : CategoryAdminPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return CustomeRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductPage(product),
            );
          }
          if (pathElements[1] == 'category') {
            final String catId = pathElements[2];
            final CategoryData category =
                _model.allCategories.firstWhere((CategoryData category) {
              return category.id == catId;
            });
            return CustomeRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : CategoryPage(category),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductsPage(_model));
        },
      ),
    );
  }
}
