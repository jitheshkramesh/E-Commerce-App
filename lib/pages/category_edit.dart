import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../widgets/form_inputs/cat_image.dart';
import '../widgets/ui_elements/adaptive_progress_indicator.dart';
import '../scoped_model/main.dart';
import '../models/category.dart';

class CategoryEditPage extends StatefulWidget {
  final MainModel model;

  CategoryEditPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _CategoryEditPageState();
  }
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  AutoCompleteTextField searchCategoryTextField;
  GlobalKey<AutoCompleteTextFieldState<CategoryData>> catKey = new GlobalKey();
  int selectedRadio;

  @override
  void initState() {
    widget.model.getCategories();
    _categories = widget.model.allCategories;
    print('Categories product Edit page length : ${_categories.length}');
    super.initState();
    selectedRadio = 0;
    //print('Category isActive value : ${widget.model.selectedCategoryId.catIsActive}');
    // try {
    //   if (widget.model.selectedCategory.catIsActive) {
    //     selectedRadio = 1;
    //   } else {
    //     selectedRadio = 2;
    //   }
    // } catch (error) {
    //   //widget.model.selectedCategory.catIsActive = false;
    //   print('Category edit page error : $error');
    // }
  }

  final Map<String, dynamic> _formData = {
    'CatDesc': Null,
    'CatIsActive': Null,
    'image': Null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _descriptionFocusNode = FocusNode();
  final _descriptionTextController = TextEditingController();
  List<CategoryData> _categories = new List<CategoryData>();

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

  Widget _buildDescriptionTextField(CategoryData category) {
    if (category == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (category != null &&
        _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = category.catDesc;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        decoration: InputDecoration(labelText: 'Description Title'),
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

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: AdaptiveProgressIndicator())
            : RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: () => _submitForm(
                    model.addCategory,
                    model.updateCategory,
                    model.selectCategory,
                    model.selectedCategoryIndex),
              );
      },
    );
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Widget _buildPageContent(BuildContext context, CategoryData category) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    print('Category isActive value checking ');
    try {
      print('Category isActive value : ${category.catIsActive}');
      if (category.catIsActive == null) {
        category.catIsActive = false;
      }
      selectedRadio =
          category.catIsActive != null ? category.catIsActive ? 1 : 2 : 0;
    } catch (error) {
      print('Category isActive value error :catch');
      selectedRadio = 0;
    }

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
              _buildDescriptionTextField(category),
              SizedBox(
                height: 10.0,
              ),
              new RadioListTile(
                value: 1,
                groupValue: selectedRadio,
                title: Text("Active"),
                onChanged: (val) {
                  print("Radio button pressed $val");
                  setSelectedRadio(val);
                },
              ),
              new RadioListTile(
                value: 2,
                groupValue: selectedRadio,
                title: Text("In Active"),
                onChanged: (val) {
                  print("Radio button pressed $val");
                  setSelectedRadio(val);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              ImageInput(_setImage, category),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _setImage(File image) {
    _formData['image'] = image;
  }

  void _submitForm(Function addCategory, Function updateCategory,
      Function setSelectedCategory,
      [int selectedProductIndex]) {
    print('Submit form reached..');
    if (!_formKey.currentState.validate() ||
        (_formData['image'] == null && selectedProductIndex == -1)) {
      return;
    }
    print('Submit form validated..');
    _formKey.currentState.save();
    bool isActive;
    if (selectedRadio == 1) {
      isActive = true;
    } else {
      isActive = false;
    }
    if (selectedProductIndex == -1) {
      addCategory(_descriptionTextController.text, _formData['image'], isActive)
          .then((bool success) {
        print('Category addCategory success 1..');
        if (success) {
          print('Category addCategory success 2..');
          Navigator.pushReplacementNamed(context, '/category')
              .then((_) => setSelectedCategory(null));
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
      updateCategory(
        _descriptionTextController.text,
        _formData['image'],
        isActive,
      ).then((_) => Navigator.pushReplacementNamed(context, '/categories')
          .then((_) => setSelectedCategory(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedCategory);
        return model.selectedCategoryIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Category'),
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
