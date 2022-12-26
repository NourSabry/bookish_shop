// ignore_for_file: non_constant_identifier_names, avoid_print, use_rethrow_when_possible, unused_local_variable, unnecessary_null_comparison

import 'package:book_shop/models/http_exceptions.dart';
import 'package:book_shop/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId,  this._items);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red whtie and loyal blue',
    //   description: 'Romance book by Casey McQuiston!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://media1.popsugar-assets.com/files/thumbor/VAfKR1KPQcrAJiHABwMhx8SFOZo/fit-in/728xorig/filters:format_auto-!!-:strip_icc-!!-/2020/03/29/943/n/43611095/4671d5319796a9f7_71skR7IaVEL/i/Red-White-Royal-Blue-by-Casey-McQuiston.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Loveless',
    //   description: 'Drama/Friendship by Alice Oseman.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://media1.popsugar-assets.com/files/thumbor/xEpq4LRZuYJYh48sL0EWkQJ8RAM/fit-in/728xorig/filters:format_auto-!!-:strip_icc-!!-/2019/10/24/642/n/46781279/609c74907de7d439_71stZUv65VL/i/Loveless-by-Alice-Oseman.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'The hunger Games',
    //   description: 'Suznna collins.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://cdn.pastemagazine.com/www/articles/2019/10/04/BalladofSongbirdsandSnakesCover.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Saga vol 10',
    //   description: 'Prepare yourself foe the best fantasy comics ever.',
    //   price: 49.99,
    //   imageUrl: 'http://cdn.pastemagazine.com/www/articles/17Saga.jpg',
    // ),
  ];

  List<Product> get getFavouritesItems {
    return _items.where((ProductItem) => ProductItem.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findbyId(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url = Uri.parse(
        'https://bookish-8d00e-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://bookish-8d00e-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

//by adding async below, all the function automaticaly turns into a future
  Future<void> addProduct(Product product) async {
    ///products.json,
    /// only with using firebase not with all apis

    final url =
        'https://bookish-8d00e-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            // "isFavorite": product.isFavorite,
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      //this is the same as _items.insert(0, newProduct),
      // it just makes you insert from the start
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://bookish-8d00e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );
      _items[prodIndex] = newProduct;
    } else {
      print('...');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://bookish-8d00e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final exisitingId = _items.indexWhere((prod) => prod.id == id);
    Product? existingItem = _items[exisitingId];
    _items.removeAt(exisitingId);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(exisitingId, existingItem);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    existingItem = null;
  }
}
