import 'package:flutter/material.dart';
import 'package:products_app/services/auth_services.dart';
import 'package:provider/provider.dart';

import 'package:products_app/models/products.dart';
import 'package:products_app/screens/loading_screen.dart';
import 'package:products_app/services/products_services.dart';
import 'package:products_app/widgets/product_card.dart';


class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final productsServices = Provider.of<ProductsServices>(context);
    final authServices = Provider.of<AuthServices>(context, listen: false);

    if(productsServices.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.login_outlined),
            onPressed: (){

              authServices.logout();
              Navigator.pushReplacementNamed(context, "login");

            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: productsServices.products.length,
        itemBuilder: (BuildContext context, int i) {

          final product = productsServices.products[i];

          return GestureDetector(
            child: ProductCard(product: product,),
            onTap: (){
              // Esta es otra forma, esto se podria pasar directamente como argumento del navigator, se hace una copia para romper la referencia
              productsServices.selectedProduct = product.copy();
              Navigator.pushNamed(context, "product");

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){

          productsServices.selectedProduct = new Product(
            available: true, 
            name: '', 
            price: 0
          );

          Navigator.pushNamed(context, "product");

        },
      ),
    );
  }
}