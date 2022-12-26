// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:book_shop/providers/cart_provider.dart';
import 'package:book_shop/providers/order_provider.dart';
import 'package:book_shop/widgets/cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart_screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(
                        cart.totalPrice.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    OrderButton(cart),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => CardWidget(
                  title: cart.items.values.toList()[index].title,
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                ),
                itemCount: cart.items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart? cart;
  const OrderButton(this.cart);
  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart!.totalPrice <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart!.items.values.toList(),
                widget.cart!.totalPrice,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart!.clear();
            },
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Text(
              "ORDER NOW",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
    );
  }
}
