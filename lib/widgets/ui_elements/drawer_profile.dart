import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_model/main.dart';

class DrawerProfile extends StatelessWidget {
  final MainModel model;
  DrawerProfile(this.model);
  @override
  Widget build(BuildContext context) {
    print('Image path : ');
    print(model.userRegister.imagePath.toString());
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return new UserAccountsDrawerHeader(
          accountName: new Text((model.userRegister.firstName == null)
              ? model.user.email
              : model.userRegister.firstName),
          accountEmail: new Text(model.user.email),
          currentAccountPicture: new GestureDetector(
            child: new CircleAvatar(
              backgroundImage: new NetworkImage(
                  (model.userRegister.imagePath == null)
                      ? 'assets/food.jpg'
                      : model.userRegister.imagePath),
            ),
          ),
          otherAccountsPictures: <Widget>[
            new CircleAvatar(
              backgroundColor: Colors.brown,
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(
                    (model.userRegister.imagePath == null)
                        ? 'assets/food.jpg'
                        : model.userRegister.imagePath),
              ),
            )
          ],
        );
      },
    );
  }
}
