// ignore_for_file: use_key_in_widget_constructors

import 'package:book_shop/providers/auth_provider.dart';
import 'package:book_shop/screens/orders_screen.dart';
import 'package:book_shop/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text(
              "Hello dear customer",
            ),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: const Text("Shop"),
            leading: const Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Orders"),
            leading: const Icon(Icons.payment),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                OrderScreen.routeName,
                // Navigator.of(context).pushReplacement(CustomRoute(
                //   builder: (ctx) => OrderScreen(),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Manage Products"),
            leading: const Icon(Icons.edit),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                UserProductsScreen.routeName,
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              //to close the drawer first
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
