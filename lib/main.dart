import 'package:flutter/material.dart';
import 'package:products_app/screens/check_auth_screen.dart';
import 'package:products_app/services/auth_services.dart';
import 'package:products_app/services/notifications_services.dart';
import 'package:provider/provider.dart';

import 'package:products_app/screens/home_screen.dart';
import 'package:products_app/screens/login_screen.dart';
import 'package:products_app/screens/register_screen.dart';
import 'package:products_app/screens/product_screen.dart';
import 'package:products_app/services/products_services.dart';
 
void main() => runApp(AppState());

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsServices()),
        ChangeNotifierProvider(create: (_) => AuthServices()),
      ],
      child: MyApp(),
    );
  }
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: "login",
      routes: {
        "home": (_) => HomeScreen(),
        "login": (_) => LoginScreen(),
        "register": (_) => RegisterScreen(),
        "product": (_) => ProductScreen(),
        "checking": (_) => CheckAuthScreen()
      },
      scaffoldMessengerKey: NotificationsServices.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }
}