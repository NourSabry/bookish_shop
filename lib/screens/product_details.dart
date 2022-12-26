// ignore_for_file: use_key_in_widget_constructors

import 'package:book_shop/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsDetailsScreen extends StatelessWidget {
  static const routeName = 'product-details';
  // final String? title;
  // const ProductsDetailsScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final idProduct = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findbyId(idProduct);
    return Scaffold(
      body: CustomScrollView(
        //slivers are a scrollable ares on the screen
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            //the appbar will always be visible when you scroll and then stick to the top
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: loadedProduct.id!,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SliverList(
            //the delegate tells it how to render the content of the list
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  "\$${loadedProduct.price}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  loadedProduct.description,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 800)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
