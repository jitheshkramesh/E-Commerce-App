import 'package:meta/meta.dart';
import './location_data.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String image;
  final double price;
  final bool isFavorite;
  final String userEmail;
  final String userId;
final LocationData location;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.userEmail,
      @required this.userId,
      @Required this.location,
      this.isFavorite = false});
}
