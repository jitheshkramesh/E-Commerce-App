import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../widgets/form_inputs/location.dart';
import '../widgets/form_inputs/image.dart';
import '../widgets/ui_elements/adaptive_progress_indicator.dart';
import '../models/product.dart';
import '../scoped_model/main.dart';
import '../models/location_data.dart';
import '../models/category.dart';

class ProductEditPage extends StatefulWidget {
  final MainModel model;

  ProductEditPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  bool _isLoading = true;
  AutoCompleteTextField searchCategoryTextField;
  GlobalKey<AutoCompleteTextFieldState<CategoryData>> catKey = new GlobalKey();

  @override
  void initState() {
    widget.model.getCategories();
    _categories = widget.model.allCategories;
    _isLoading = false;
    print('Categories product Edit page length : ${_categories.length}');
    super.initState();
  }

  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': null,
    'location': null,
    'catId': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _titleTextEditController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _categoryTextEditController = TextEditingController();
  List<CategoryData> _categories = new List<CategoryData>();

  Widget _buildCategoryTextField() {
    // if (catId == null && _categoryTextEditController.text.trim() == '') {
    //   _categoryTextEditController.text = '';
    // } else if (catId != null && _categoryTextEditController.text.trim() == '') {
    //   _categoryTextEditController.text = catId.toString();
    // } else if (catId != null && _categoryTextEditController.text.trim() != '') {
    //   _categoryTextEditController.text = _categoryTextEditController.text;
    // } else if (catId == null && _categoryTextEditController.text.trim() != '') {
    //   _categoryTextEditController.text = _categoryTextEditController.text;
    // } else {
    //   _categoryTextEditController.text = '';
    // }

    print('Categories product Edit Widget page length : ${_categories.length}');

    return EnsureVisibleWhenFocused(
      focusNode: _categoryFocusNode,
      child: searchCategoryTextField = AutoCompleteTextField<CategoryData>(
        key: catKey,
        clearOnSubmit: false,
        suggestions: _categories,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
          hintText: "Search Category",
          hintStyle: TextStyle(color: Colors.black),
        ),
        itemFilter: (item, query) {
          return item.catDesc.toLowerCase().contains(query.toLowerCase());
        },
        itemSorter: (a, b) {
          return a.catDesc.compareTo(b.catDesc);
        },
        itemSubmitted: (item) {
          setState(() {
            searchCategoryTextField.textField.controller.text = item.catDesc;
            _categoryTextEditController.text = item.id;
          });
        },
        itemBuilder: (context, item) {
          // ui for autocomplete row
          return row(item);
        },
      ),
    );
  }

  Widget row(CategoryData category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          category.catDesc,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          category.catDesc,
        )
      ],
    );
  }

  Widget _buildTitleTextField(Product product) {
    if (product == null && _titleTextEditController.text.trim() == '') {
      _titleTextEditController.text = '';
    } else if (product != null && _titleTextEditController.text.trim() == '') {
      _titleTextEditController.text = product.title;
    } else if (product != null && _titleTextEditController.text.trim() != '') {
      _titleTextEditController.text = _titleTextEditController.text;
    } else if (product == null && _titleTextEditController.text.trim() != '') {
      _titleTextEditController.text = _titleTextEditController.text;
    } else {
      _titleTextEditController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Product Title'),
        controller: _titleTextEditController,
        //initialValue: product == null ? '' : product.title.toString(),
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Title is required and should be 5+ characters long.';
          }
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    if (product == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (product != null &&
        _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = product.description;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        decoration: InputDecoration(labelText: 'Description Title'),
        //initialValue: product == null ? '' : product.description.toString(),
        controller: _descriptionTextController,
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Description is required and should be 5+ characters long.';
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField(Product product) {
    if (product == null && _priceTextController.text.trim() == '') {
      _priceTextController.text = '';
    } else if (product != null && _priceTextController.text.trim() == '') {
      _priceTextController.text = product.price.toString();
    }
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Product Price'),
        controller: _priceTextController,
        //initialValue: product == null ? '' : product.price.toString(),
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
            return 'Price is required and should be number.';
          }
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: AdaptiveProgressIndicator())
            : RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _isLoading
                  ? CircularProgressIndicator()
                  : _buildCategoryTextField(),
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(
                height: 10.0,
              ),
              LocationInput(_setLocation, product),
              SizedBox(
                height: 10.0,
              ),
              ImageInput(_setImage, product),

              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My Button'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _setLocation(LocationData locData) {
    _formData['location'] = locData;
  }

  void _setImage(File image) {
    _formData['image'] = image;
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate() ||
        (_formData['image'] == null && selectedProductIndex == -1)) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(
              _titleTextEditController.text,
              _descriptionTextController.text,
              _formData['image'],
              double.parse(
                  _priceTextController.text.replaceFirst(RegExp(r','), '.')),
              _formData['location'],
              _categoryTextEditController.text)
          .then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong!'),
                  content: Text('Please try again!'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        }
      });
    } else {
      updateProduct(
        _titleTextEditController.text,
        _descriptionTextController.text,
        _formData['image'],
        double.parse(_priceTextController.text.replaceFirst(RegExp(r','), '.')),
        _formData['location'],
        _categoryTextEditController.text,
      ).then((_) => Navigator.pushReplacementNamed(context, '/products')
          .then((_) => setSelectedProduct(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                  elevation: Theme.of(context).platform == TargetPlatform.iOS
                      ? 0.0
                      : 4.0,
                ),
                body: pageContent,
              );
      },
    );
  }
}
