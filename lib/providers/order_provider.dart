// ignore_for_file: list_remove_unrelated_type, prefer_final_fields, avoid_print, non_constant_identifier_names, unnecessary_null_comparison

import 'package:book_shop/providers/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.amount,
    required this.dateTime,
    required this.id,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authoken;
  final String userId;

  Orders(this.authoken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndStoreOrders() async {
    final url =
        'https://bookish-8d00e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authoken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadeOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadeOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
        ),
      );
    });
    //to show them from the newsest
    _orders = loadeOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double amount) async {
    final url =
        'https://bookish-8d00e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authoken';
    final dateStamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': amount,
          'dateTime': dateStamp.toIso8601String(),
          'products': cartItems
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));
    //Add will always insert at the end of the array, while Insert allows you to select an index
    _orders.insert(
      0,
      OrderItem(
        amount: amount,
        dateTime: dateStamp,
        id: json.decode(response.body)['name'],
        products: cartItems,
      ),
    );
    notifyListeners();
  }
}
