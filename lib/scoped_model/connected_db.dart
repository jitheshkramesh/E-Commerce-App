import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../models/userRegister.dart';
import '../models/auth.dart';
import '../models/location_data.dart';
import '../models/category.dart';

mixin Connected_dbModel on Model {
  List<Product> _products = [];
  List<CategoryData> _categories = [];
  String _selProductId;
  String _selCategoryId;
  User _authenticatedUser;
  UserRegister _register;
  bool _isLoading = false;
}

mixin CategoriesModel on Connected_dbModel {
  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-flutter-products-df0ff.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong Upload Image');
        print(json.decode(response.body) + 'from print method');
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addCategory(
      String description, File image, bool isActive) async {
    _isLoading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);
    if (uploadData == null) {
      print('Upload faild!');
      return false;
    }

    final Map<String, dynamic> categoryData = {
      'CatDesc': description,
      'CatIsActive': isActive,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'imagePath': uploadData['imagePath'],
      'ImageUrl': uploadData['imageUrl']
    };
    try {
      final http.Response response = await http.post(
          'https://flutter-products-df0ff.firebaseio.com/Category.json?auth=${_authenticatedUser.token}',
          body: json.encode(categoryData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);

      final CategoryData newCategory = CategoryData(
          id: responseData['name'],
          catDesc: description,
          catIsActive: responseData['CatIsActive'] ? true : false,
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _categories.add(newCategory);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCategory(
      String description, File image, bool isActive) async {
    _isLoading = true;
    notifyListeners();
    String imageUrl = selectedCategory.image;
    String imagePath = selectedCategory.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);
      if (uploadData == null) {
        print('Upload faild!');
        return false;
      }

      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }

    final Map<String, dynamic> updateData = {
      'CatDesc': description,
      'CatIsActive': isActive,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'userEmail': selectedCategory.userEmail,
      'userId': selectedCategory.userId
    };
    try {
      await http.put(
          'https://flutter-products-df0ff.firebaseio.com/Category/${selectedCategory.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateData));

      _isLoading = false;

      final CategoryData updatedCategory = CategoryData(
          id: selectedCategory.id,
          catDesc: description,
          catIsActive: isActive,
          image: imageUrl,
          imagePath: imagePath,
          userEmail: selectedCategory.userEmail,
          userId: selectedCategory.userId);

      _categories[selectedCategoryIndex] = updatedCategory;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchCategories({onlyforUser = false, clearExisting = false}) {
    print('Category list');
    _isLoading = true;
    if (clearExisting) _categories = [];
    notifyListeners();
    return http
        .get(
            'https://flutter-products-df0ff.firebaseio.com/Category.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      _isLoading = false;
      final List<CategoryData> fetchedCategoryList = [];
      final Map<String, dynamic> _categoryData = json.decode(response.body);
      if (_categoryData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      print('Category list count ${_categoryData.length}');
      _categoryData.forEach((String catId, dynamic _categoryData) {
        final CategoryData categoryData = CategoryData(
          id: catId,
          catDesc: _categoryData['CatDesc'],
          // catIsActive:
          //     (bool.fromEnvironment(_categoryData['CatIsActive']) == true)
          //         ? true
          //         : false,
          catIsActive: _categoryData['CatIsActive'] ? true : false,
          image: _categoryData['ImageUrl'],
          imagePath: _categoryData['imagePath'],
          userEmail: _categoryData['userEmail'],
          userId: _categoryData['userId'],
        );
        fetchedCategoryList.add(categoryData);
      });
      _categories = fetchedCategoryList.where((CategoryData category) {
        return category.userId == _authenticatedUser.id;
      }).toList();

      print('Category list fetched count ${_categories.length}');
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      print('Category list fetched count error.');
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void getCategories() async {
    //Map<String, dynamic> _categoryData;
    try {
      final response = await http.get(
          'https://flutter-products-df0ff.firebaseio.com/Category.json?auth=${_authenticatedUser.token}');
      if (response.statusCode == 200) {
        //_categories = loadCategories(response.body);
        final List<CategoryData> fetchedCategoryList = [];
        Map<String, dynamic> _categoryData = json.decode(response.body);
        print('before foreach');
        _categoryData.forEach((String catId, dynamic _categoryData) {
          final CategoryData categoryData = CategoryData(
              id: catId,
              catDesc: _categoryData['CatDesc'],
              catIsActive: _categoryData['CatIsActive'] ? true : false,
              imagePath: _categoryData['imagePath'],
              userEmail: _categoryData['userEmail'],
              userId: _categoryData['userId']);
          fetchedCategoryList.add(categoryData);
        });
        _categories = fetchedCategoryList.toList();
        print('Categories success');

        print('Categories length : ${_categoryData.length}');
        //print('Categories length : ${_categories.length}');
        // _categories = fetchedCategoryList.where((CategoryData category) {
        //   return;
        // }).toList();
      } else {
        print('Errors getting Categories.');
      }
    } catch (e) {
      print('Errors catch getting Categories.');
    }
  }

  static List<CategoryData> loadCategories(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed
        .map<CategoryData>((json) => CategoryData.fromJson(json))
        .toList();
  }

  List<CategoryData> get displayedCategories {
    return List.from(_categories.toList());
  }

  List<CategoryData> get allCategories {
    return List.from(_categories);
  }

  int get selectedCategoryIndex {
    return _categories.indexWhere((CategoryData category) {
      return category.id == _selCategoryId;
    });
  }

  String get selectedCategoryId {
    return _selCategoryId;
  }

  CategoryData get selectedCategory {
    if (selectedCategoryId == null) {
      return null;
    }
    return _categories.firstWhere((CategoryData category) {
      return category.id == _selCategoryId;
    });
  }

  void selectCategory(String categoryId) {
    _selCategoryId = categoryId;
    if (categoryId == null) {
      notifyListeners();
    }
  }
}

mixin ProductsModel on Connected_dbModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return List.from(
          _products.where((Product product) => product.isFavorite).toList());
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-flutter-products-df0ff.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong Upload Image');
        print(json.decode(response.body) + 'from print method');
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addProduct(String title, String description, File image,
      double price, LocationData locData, String catId) async {
    _isLoading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);
    if (uploadData == null) {
      print('Upload faild!');
      return false;
    }

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'loc_lat': locData.latitude,
      'loc_lan': locData.longitude,
      'loc_address': locData.address,
      'catId': catId
    };
    try {
      final http.Response response = await http.post(
          'https://flutter-products-df0ff.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
          // image: '',
          // imagePath: '',
          price: price,
          location: locData,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id,
          catId: catId);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
      // .catchError((error) {
      //   _isLoading = false;
      //   notifyListeners();
      //   return false;
      // });
    }
  }

  Future<bool> updateProduct(String title, String description, File image,
      double price, LocationData locData, String catId) async {
    _isLoading = true;
    notifyListeners();
    String imageUrl = selectedProduct.image;
    String imagePath = selectedProduct.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);
      if (uploadData == null) {
        print('Upload faild!');
        return false;
      }

      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'price': price,
      'loc_lat': locData.latitude,
      'loc_lan': locData.longitude,
      'loc_address': locData.address,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId,
      'catId': catId
    };
    try {
      await http.put(
          'https://flutter-products-df0ff.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateData));

      _isLoading = false;

      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: imageUrl,
          imagePath: imagePath,
          price: price,
          location: locData,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          catId: catId);

      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-products-df0ff.firebaseio.com/products/$deletedProductId.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts({onlyforUser = false, clearExisting = false}) {
    print('Product list');
    _isLoading = true;
    if (clearExisting) _products = [];
    notifyListeners();
    return http
        .get(
            'https://flutter-products-df0ff.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      _isLoading = false;
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      print('Product list count ${productListData.length}');
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['imageUrl'],
            imagePath: productData['imagePath'],
            price: productData['price'],
            catId: productData['CatId'],
            location: LocationData(
                address: productData['loc_address'],
                latitude: productData['loc_lat'],
                longitude: productData['loc_lng']),
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id));
        fetchedProductList.add(product);
      });
      _products = fetchedProductList.where((Product product) {
        return product.userId == _authenticatedUser.id;
        //return product.userId == product.userId;
      }).toList();

      print('Product list fetched count ${_products.length}');
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      print('Product list fetched count error.');
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurrentlyFavorite =
        selectedProduct.isFavorite == null ? false : selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final int toggledProductIndex = _products.indexWhere((Product product) {
      return product.id == selectedProduct.id;
    });
    final Product updateProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        imagePath: selectedProduct.imagePath,
        // image: '',
        // imagePath: '',
        location: selectedProduct.location,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus,
        catId: selectedProduct.catId);
    _products[toggledProductIndex] = updateProduct;
    notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://flutter-products-df0ff.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
      if (response.statusCode != 200 && response.statusCode != 201) {
        final Product updateProduct = Product(
            id: selectedProduct.id,
            title: selectedProduct.title,
            description: selectedProduct.description,
            price: selectedProduct.price,
            image: selectedProduct.image,
            imagePath: selectedProduct.imagePath,
            // image: '',
            // imagePath: '',
            location: selectedProduct.location,
            userEmail: selectedProduct.userEmail,
            userId: selectedProduct.userId,
            isFavorite: !newFavoriteStatus,
            catId: selectedProduct.catId);
        _products[selectedProductIndex] = updateProduct;
        notifyListeners();
      }
    } else {
      response = await http.delete(
          'https://flutter-products-df0ff.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updateProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          imagePath: selectedProduct.imagePath,
          // image: '',
          // imagePath: '',
          location: selectedProduct.location,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteStatus,
          catId: selectedProduct.catId);
      _products[selectedProductIndex] = updateProduct;
      notifyListeners();
    }
    //_selProductId = null;
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    if (productId == null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on Connected_dbModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    print('Is authenticated from connected products');
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    print('authentication reached!');
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBk5PLrk-3tRbdCy2W3RAWV_CcX-wHLTOU',
          body: json.encode(authData),
          headers: {'Context-Type': 'application/json'});
    } else {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBk5PLrk-3tRbdCy2W3RAWV_CcX-wHLTOU',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }
    print('Authentication completed!');
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded';
      print(message);

      //print('User registration starting...');
      //userRegister(responseData['localId'], responseData['idToken'], email);
      //print('user name is ${_authenticatedUser.register.firstName}');

      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      //UserRegisterModel userRegisterModel;
      _userRegisterData(_authenticatedUser.id);
      print('User Register success');

      final String firstName = prefs.getString('firstName');
      final String secondName = prefs.getString('secondName');
      final String contactNo = prefs.getString('contactNo');
      final String dob = prefs.getString('dob');
      final String imagePath = prefs.getString('imagePath');
      _register = UserRegister(
          firstName: firstName,
          secondName: secondName,
          contactNo: contactNo,
          dob: dob,
          imagePath: imagePath);

      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This Email already exists';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This Email was not found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid';
    }

    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void _userRegisterData(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await http
          .get(
              'https://flutter-products-df0ff.firebaseio.com/UserRegister/$userId.json?auth=${_authenticatedUser.token}')
          .then<Null>((http.Response response) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('firstName') != null) {
          _register = UserRegister(
              firstName: responseData['firstName'],
              secondName: responseData['secondName'],
              contactNo: responseData['contactNo'],
              dob: responseData['dob'],
              imagePath: responseData['imagePath']);

          prefs.setString('firstName', responseData['firstName']);
          prefs.setString('secondName', responseData['secondName']);
          prefs.setString('contactNo', responseData['contactNo']);
          prefs.setString('dob', responseData['dob']);
          prefs.setString('imagePath', responseData['imagePath']);
        }
      });
    } catch (error) {
      print('User Register error cache_userRegisterData');
      _register = UserRegister(
          firstName: 'FirstName',
          secondName: 'secondName',
          contactNo: 'contactNo',
          dob: 'dob',
          imagePath: 'imagePath');
    }
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        _register = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);

      final String firstName = prefs.getString('firstName');
      final String secondName = prefs.getString('secondName');
      final String contactNo = prefs.getString('contactNo');
      final String dob = prefs.getString('dob');
      final String imagePath = prefs.getString('imagePath');
      _register = UserRegister(
          firstName: firstName,
          secondName: secondName,
          contactNo: contactNo,
          dob: dob,
          imagePath: imagePath);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _register = null;
    _authTimer.cancel();
    _userSubject.add(false);
    _selProductId = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), () {
      logout();
      _userSubject.add(false);
    });
  }
}

mixin UserRegisterModel on Connected_dbModel {
  UserRegister get userRegister {
    return _register;
  }
}

mixin UtilityModel on Connected_dbModel {
  bool get isLoading {
    return _isLoading;
  }
}
