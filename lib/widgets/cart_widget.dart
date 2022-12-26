// ignore_for_file: use_key_in_widget_constructors

import 'package:book_shop/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  final String? title;
  final String? id;
  final double? price;
  final int? quantity;
  final String? productId;

  const CardWidget({
    this.title,
    this.price,
    this.quantity,
    this.id,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: ((direction) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(productId!);
      }),
      background: const Card(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              "Are you sure?",
            ),
            content: const Text(
              "Do you want to remove the item from the cart?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Provider.of<Cart>(
                    context,
                    listen: false,
                  ).removeItem(productId!);
                  Navigator.of(ctx).pop(true);
                },
                child: const Text(
                  "yes",
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text(
                  "No",
                ),
              ),
            ],
          ),
        );
        return null;
      },
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    price.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              title!,
            ),
            subtitle: Text(
              "total is: \$${(price! * quantity!)} ",
            ),
            trailing: Text(
              " $quantity x",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
