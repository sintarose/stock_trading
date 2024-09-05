import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoack_trade/pages/login_page.dart';
import 'package:stoack_trade/services/stock_controller.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StockController(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Stock Watchlist',
      home: LoginScreen(),
    );
  }
}
