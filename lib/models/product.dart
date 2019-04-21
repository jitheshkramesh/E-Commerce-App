import 'package:meta/meta.dart';
import './location_data.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String image;
  final String imagePath;
  final double price;
  final bool isFavorite;
  final String userEmail;
  final String userId;
  final String catId;
  final LocationData location;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.userEmail,
      @required this.userId,
      @required this.location,
      @required this.imagePath,
      @required this.catId,
      this.isFavorite = false});
}
