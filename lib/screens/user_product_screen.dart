// ignore_for_file: unused_element

import 'package:book_shop/providers/products_provider.dart';
import 'package:book_shop/screens/edit_product.dart';
import 'package:book_shop/widgets/app_drawer.dart';
import 'package:book_shop/widgets/user_product_item.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "user-product";
  const UserProductsScreen({super.key});

  Future<void> _refreshPage(BuildContext context) async {
     await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          " Your Products",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditUserProduct.routeName);
            },
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshPage(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshPage(context),
                    child: Consumer<Products>(
                      builder: (ctx , productsData , _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductWidget(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].imageUrl,
                              ),
                              const Divider(),
                            ],
                          ),
                          itemCount: productsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
