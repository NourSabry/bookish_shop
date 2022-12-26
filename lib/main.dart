// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:book_shop/helpers/custom_route.dart';
import 'package:book_shop/providers/auth_provider.dart';
import 'package:book_shop/providers/cart_provider.dart';
import 'package:book_shop/providers/order_provider.dart';
import 'package:book_shop/providers/products_provider.dart';
import 'package:book_shop/screens/splash_screen.dart';
import 'package:book_shop/screens/auth_screen.dart';
import 'package:book_shop/screens/cart_screen.dart';
import 'package:book_shop/screens/edit_product.dart';
import 'package:book_shop/screens/orders_screen.dart';
import 'package:book_shop/screens/product_details.dart';
import 'package:book_shop/screens/products_overview.dart';
import 'package:book_shop/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //it will only rebuild widgets that are listening

      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        //the first is the one you depend on it
        // and the second is the the one that will be provided
        ChangeNotifierProxyProvider<Auth, Products>(
          update: ((ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items)),
          create: (ctx) => Products('', '', []),
        ),

        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', [], ''),
          update: ((ctx, auth, previousOrders) => Orders(
                auth.token,
                previousOrders == null ? [] : previousOrders.orders,
                auth.userId,
              )),
        ),
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, _) => MaterialApp(
              title: 'Bookish store',
              home: auth.isAuth
                  ? ProductsOverViewScreen()
                  : FutureBuilder(
                      builder: (ctx, authesultSnapShot) =>
                          authesultSnapShot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                      future: auth.tryAutoLogin(),
                    ),
              theme: ThemeData(
                  fontFamily: GoogleFonts.lato().toString(),
                  accentColor: const Color(0xFF94A494),
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: const Color(0xFF947464),
                    secondary: const Color(0xFF3C2631),
                    onPrimaryContainer: const Color.fromARGB(255, 255, 220, 184)
                        .withOpacity(0.3),
                  ),
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  })),
              routes: {
                ProductsDetailsScreen.routeName: (ctx) =>
                    ProductsDetailsScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                UserProductsScreen.routeName: (ctx) =>
                    const UserProductsScreen(),
                EditUserProduct.routeName: (ctx) => EditUserProduct(),
              },
            )),
      ),
    );
  }
}
