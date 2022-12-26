// ignore_for_file: use_key_in_widget_constructors, avoid_print, non_constant_identifier_names

import 'package:book_shop/providers/order_provider.dart';
import 'package:book_shop/widgets/app_drawer.dart';
import 'package:book_shop/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "orders";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // we don't need to build that here, but we are doing it beacuse it will help
  //with other applications when you don't need the all widget the build from the start
  //just beacuse something lke the title or smth changed

  Future? _Ordersfuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndStoreOrders();
  }

  @override
  void initState() {
    _Ordersfuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building orders");
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Order",
          ),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            //now you ensure that no new future is created just beacuse your
            //widget rebuild(that doesn't happen here but just for ur followings projects)
            future: _Ordersfuture,
            builder: (context, dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (context, index) => OrderWidget(
                      orderData.orders[index],
                    ),
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }));
  }
}
