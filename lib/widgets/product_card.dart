
import 'package:flutter/material.dart';
import 'package:products_app/models/products.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({
    Key? key, 
    required this.product  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [

            _BackgroundImage(urlImage: product.picture,),

            _ProductDetails(productDetails: product.name, id: product.id!),

            Positioned(
              child: _PriceTag(price: product.price,),
              top: 0,
              right: 0,
            ),

            if(!product.available)
              
              Positioned(
                child: _NotAvailable(),
                top: 0,
                left: 0,
              )
            

          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0,7)
          )
        ]
      );
  }
}

class _NotAvailable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("No Disponible", style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {

  final double price;

  const _PriceTag({
    required this.price
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("\$$price", style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {

  final String productDetails;
  final String id;

  const _ProductDetails({
    required this.productDetails,
    required this.id,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("$productDetails", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),

            Text(id, style: TextStyle(fontSize: 15, color: Colors.white))

          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25)),
  );

}

class _BackgroundImage extends StatelessWidget {

  final String? urlImage;

  const _BackgroundImage({
    this.urlImage
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: FadeInImage(
          placeholder: AssetImage("assets/jar-loading.gif"),
          image: NetworkImage(urlImage ?? "https://www.emsevilla.es/wp-content/uploads/2020/10/no-image-1.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}