// ignore_for_file: use_key_in_widget_constructors, avoid_print, unnecessary_null_comparison, unused_field, prefer_void_to_null, use_build_context_synchronously

import 'package:book_shop/models/product.dart';
import 'package:book_shop/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUserProduct extends StatefulWidget {
  static const routeName = "edit-product";

  @override
  State<EditUserProduct> createState() => _EditUserProductState();
}

class _EditUserProductState extends State<EditUserProduct> {
  final _priceFocusNode = FocusNode();
  final _decriptionFocusNode = FocusNode();
  final _imageFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  Product _editiedProduct = Product(
    id: null,
    title: "",
    imageUrl: "",
    description: "",
    price: 0,
  );
  var _initState = true;
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    //_updateImageUrl would be excuted whenever the state changes
    _imageFocus.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editiedProduct = Provider.of<Products>(context).findbyId(productId);
        _initValue = {
          'description': _editiedProduct.description,
          'imageUrl': '',
          'price': _editiedProduct.price.toString(),
          'title': _editiedProduct.title,
        };
        _imageUrlController.text = _editiedProduct.imageUrl;
      }
    }
    _initState = false;
    super.didChangeDependencies();
  }

  @override
  //we have to dispose the focuse node when your state gets clean,
  //otherwise it would stic around in memory and will lead to a memory leak
  void dispose() {
    _imageFocus.removeListener(_updateImageUrl);
    _decriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocus.hasFocus) {
      {
        if (_imageUrlController.text.isEmpty ||
            (!_imageUrlController.text.startsWith('http') &&
                !_imageUrlController.text.startsWith('https')) ||
            (!_imageUrlController.text.endsWith('.jpg') &&
                !_imageUrlController.text.endsWith('.png') &&
                !_imageUrlController.text.endsWith('c=1') &&
                !_imageUrlController.text.endsWith('.jpeg'))) {
          return;
        }
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    //wil trigger a method onm every textFormField in your form which allow you
    //to take the value you enterd in every field and do  with it whatever you want
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editiedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editiedProduct.id!, _editiedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editiedProduct);
      } catch (error) {
        //the null here tells the function that you're not waiting for any return
        // and the cvalue will always be nul; so  the pop works
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("An Error Occured!"),
            content: const Text("Something went wrong"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("Okay!"),
              )
            ],
          ),
        );
      }
      //when you put smth into finally, it runs whatever hppened before it
      //will always run
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    //as we have 3 await above, this setState would be the final
    //func to be excted after w succesfully finish the whole 3 functions
    //so the finally method isn't ready needed here
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit proudct"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: const InputDecoration(
                        label: Text("title"),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        //when user finish here, he'll find the next button in the keyboard,
                        // it would go directly to the text mod in the next field so the user
                        // wouldn't need to click there himself
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editiedProduct = Product(
                          id: _editiedProduct.id,
                          title: value!,
                          imageUrl: _editiedProduct.imageUrl,
                          description: _editiedProduct.description,
                          price: _editiedProduct.price,
                          isFavorite: _editiedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          //the text wth the return here would e as an error message
                          return 'you should give your book a title';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        setState(() {});
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: const InputDecoration(
                        label: Text("price"),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_decriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editiedProduct = Product(
                            id: _editiedProduct.id,
                            title: _editiedProduct.title,
                            imageUrl: _editiedProduct.imageUrl,
                            description: _editiedProduct.description,
                            price: double.parse(value!),
                            isFavorite: _editiedProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter the price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'please enter a valid number';
                        }
                        if (double.tryParse(value)! <= 0) {
                          return 'please enter a number more than 0';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      maxLines: 3,
                      decoration: const InputDecoration(
                        label: Text("description"),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _decriptionFocusNode,
                      onSaved: (value) {
                        _editiedProduct = Product(
                            id: _editiedProduct.id,
                            title: _editiedProduct.title,
                            imageUrl: _editiedProduct.imageUrl,
                            description: value!,
                            price: _editiedProduct.price,
                            isFavorite: _editiedProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please just enter a description';
                        }
                        if (value.length < 5) {
                          return 'should be at more than 5 characters';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 9,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text("enter a url")
                              : FittedBox(
                                  fit: BoxFit.fill,
                                  //https://cdn11.bigcommerce.com/s-gjd9kmzlkz/images/stencil/2560w/products/22405/22230/seven_9781501161933__08751.1607045647.jpg?c=1 , image to try
                                  child: Image.network(
                                    _imageUrlController.text,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text("Image Url"),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageFocus,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (value) {
                              _editiedProduct = Product(
                                  id: _editiedProduct.id,
                                  title: _editiedProduct.title,
                                  imageUrl: value!,
                                  description: _editiedProduct.description,
                                  price: _editiedProduct.price,
                                  isFavorite: _editiedProduct.isFavorite);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your book image';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'please enter a valid url';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('c=1') &&
                                  !value.endsWith('.jpeg')) {
                                return 'please enter a valid url';
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: _saveForm,
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(50, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                        child: const Text("Add my book"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
