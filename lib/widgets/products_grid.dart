// ignore_for_file: use_key_in_widget_constructors

import 'package:book_shop/providers/products_provider.dart';
import 'package:book_shop/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridProduct extends StatelessWidget {
  final bool showFavs;

  const GridProduct(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.getFavouritesItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) =>
       ChangeNotifierProvider.value(
        value:   products[index],
        child: ProductItem(
            // title: products[index].title,
            // imageUrl: products[index].imageUrl,
            // id: products[index].id,
            ),
      ),
      itemCount: products.length,
    );
  }
}
