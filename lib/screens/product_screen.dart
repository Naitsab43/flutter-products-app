import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:products_app/providers/product_form_provider.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/services/products_services.dart';
import 'package:products_app/widgets/product_image.dart';


class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productServices = Provider.of<ProductsServices>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productServices.selectedProduct),
      child: _ProductScreenBody(productServices: productServices),
    );

  }

}

class _ProductScreenBody extends StatelessWidget {

  const _ProductScreenBody({
    Key? key,
    required this.productServices,
  }) : super(key: key);

  final ProductsServices productServices;

  @override
  Widget build(BuildContext context) {


    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
      
                  ProductImage(urlImage: productServices.selectedProduct.picture,),
      
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.grey,),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    top: 30,
                    left: 20,
                  ),
      
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey,),
                      onPressed: () async {
                        
                        final picker = new ImagePicker();

                        final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

                        if( pickedFile == null) return;

                        productServices.updateSelectedProductImage(pickedFile.path);

                      },
                    ),
                    top: 30,
                    right: 30,
                  ),
      
                ],
              ),
              _ProductForm(),
              SizedBox(height: 100)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: productServices.isSaving ? CircularProgressIndicator(color: Colors.white,) : Icon(Icons.save_outlined),
        onPressed: productServices.isSaving ? null : () async {

          if(!productForm.isValidForm()) return ;

          final String? imageUrl = await productServices.uploadImage();

          if(imageUrl != null) productForm.product.picture = imageUrl;

          await productServices.saveOrCreateProduct(productForm.product);

          // Cierra teclado
          FocusScope.of(context).requestFocus(new FocusNode());

        },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [

              SizedBox(height: 10,),

              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {

                  if(value == null || value.length < 1){
                    return "El nombre es obligatorio";
                  }

                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: "Nombre del producto", 
                  labelText: "Nombre"
                ),
              ),

              SizedBox(height: 30,),

              TextFormField(
                initialValue: "${product.price}",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {

                  if(double.tryParse(value) == null){
                    product.price = 0;
                  }
                  else {
                    product.price = double.parse(value);
                  }
                  
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: "\$150", 
                  labelText: "Precio"
                ),
              ),
              SizedBox(height: 30,),

              SwitchListTile.adaptive(
                value: product.available, 
                title: Text("Disponible"),
                activeColor: Colors.indigo,
                onChanged: (value) => productForm.updateAvailability(value)
              ),

              SizedBox(height: 30,),

            ],
          ),
        ),
      ),
    );

  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0,5)
        )
      ]
    );
  }
}