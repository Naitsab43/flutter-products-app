

import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {

  final String? urlImage;

  const ProductImage({this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 450,
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          child: _getImage(this.urlImage)
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.black45,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0,5),
        blurRadius: 10
      )
    ]
  );

  Widget _getImage(String? urlImage ) {

    if(urlImage == null)
      return FadeInImage(
        image: NetworkImage("https://www.emsevilla.es/wp-content/uploads/2020/10/no-image-1.png"),
        placeholder: AssetImage("assets/jar-loading.gif"),
        fit: BoxFit.cover,
      );

    if(urlImage.startsWith("http"))

      return FadeInImage(
        image: NetworkImage(urlImage),
        placeholder: AssetImage("assets/jar-loading.gif"),
        fit: BoxFit.cover,
      );


    return Image.file(
      File(urlImage),
      fit: BoxFit.cover,
    );  


  }


}

