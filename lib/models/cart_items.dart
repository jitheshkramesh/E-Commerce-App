import 'package:meta/meta.dart';

class CartItems {
  final String id;
  final String catId;
  final String prodId;
  final String prodTitle;
  final String prodDescription;
  final String prodImage;
  final String prodImagePath;
  final double prodPrice;
  final bool isPaid;
  final bool isDelivered;
  final String userEmail;
  final String userId;
  

  CartItems(
      {@required this.id,
      @required this.catId,
      @required this.prodId,
      @required this.prodTitle,
      @required this.prodDescription,
      @required this.prodImage,
      @required this.prodImagePath,
      @required this.prodPrice,
      @required this.userEmail,
      @required this.userId,
      this.isPaid = false,
      this.isDelivered = false});
}
