// ignore_for_file: use_key_in_widget_constructors

import 'package:book_shop/providers/products_provider.dart';
import 'package:book_shop/screens/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductWidget extends StatelessWidget {
  final String? id;
  final String? title;
  final String? imageUrl;
  const UserProductWidget(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title!),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl!,
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditUserProduct.routeName,
                  arguments: id,
                );
              },
              icon: const Icon(
                Icons.edit,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id!);
                } catch (error) {
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Deleting Failed!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.delete,
              ),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
