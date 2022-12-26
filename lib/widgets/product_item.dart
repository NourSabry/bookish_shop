// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:book_shop/models/product.dart';
import 'package:book_shop/providers/auth_provider.dart';
import 'package:book_shop/providers/cart_provider.dart';
import 'package:book_shop/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String? imageUrl;
  // final String? title;
  // final String? id;
  // const ProductItem({this.id, this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Product>(context, listen: false);
    final card = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              products.toggleFavouriteStatus(authData.token, authData.userId);
            },
            icon: Consumer<Product>(
              builder: (ctx, product, _) => Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              card.addItem(
                products.id!,
                products.price,
                products.title,
              );
              //we call the nearest scaffold that control the page
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  content: const Text("added to the cart"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      card.removeSingleItem(products.id!);
                    },
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_bag,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 20,
            ),
          ),
          title: Text(
            products.title,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductsDetailsScreen.routeName,
              arguments: products.id,
            );
          },
          child: Hero(
            //it's not importtant which tag you'll use as long as it's unique
            //so it knows what picture to use
            tag: products.id!,
            child: FadeInImage(
              placeholder:
                  const AssetImage("assets/images/board.png"),
              image: NetworkImage(products.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
