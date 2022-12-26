// ignore_for_file: use_key_in_widget_constructors, avoid_print, no_leading_underscores_for_local_identifiers

import 'package:book_shop/providers/cart_provider.dart';
import 'package:book_shop/providers/products_provider.dart';
import 'package:book_shop/screens/cart_screen.dart';
import 'package:book_shop/widgets/app_drawer.dart';
import 'package:book_shop/widgets/badge.dart';
import 'package:book_shop/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilteredValue { favouritesOnly, showAll }

class ProductsOverViewScreen extends StatefulWidget {
  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavourite = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); won't work here
    //so we can use:
    //Future.delayed(Duration.zero).then((_){
    //Provider.of<Products>(context).fetchAndSetProducts();
    //})     this will work but we gonna try another approach
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bookish Treasure",
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showOnlyFavourite = true;
              setState(() {
                FilteredValue.favouritesOnly;
              });
            },
            icon: const Icon(Icons.favorite),
          ),
          // PopupMenuButton(
          //   onSelected: (FilteredValue selectedValue) {
          //     setState(() {
          //       if (selectedValue == FilteredValue.favouritesOnly) {
          //         _showOnlyFavourite = true;
          //       } else {
          //         _showOnlyFavourite = false;
          //       }
          //     });
          //   },
          //   icon: const Icon(
          //     Icons.more_vert,
          //   ),
          //   itemBuilder: (_) => [
          //     const PopupMenuItem(
          //       value: FilteredValue.favouritesOnly,
          //       child: Text(
          //         "Only Favorites",
          //       ),
          //     ),
          //     const PopupMenuItem(
          //       value: FilteredValue.showAll,
          //       child: Text(
          //         "show all",
          //       ),
          //     ),
          //   ],
          // ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              value: cartData.itemCount.toString(),
              color: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(Icons.shopping_bag),
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridProduct(
              _showOnlyFavourite,
            ),
    );
  }
}
