import 'package:flutter/material.dart';
import 'package:products_app/providers/login_provider.dart';
import 'package:products_app/services/auth_services.dart';
import 'package:products_app/services/notifications_services.dart';
import 'package:provider/provider.dart';

import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/auth_background.dart';
import 'package:products_app/widgets/card_container.dart';


class LoginScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 250,),
              CardContainer(
                child: Column(
                  children: [

                    SizedBox(height: 10,),
                    Text("Login", style: Theme.of(context).textTheme.headline4,),
                    SizedBox(height: 30,),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    )

                  ],
                )
              ),
              SizedBox(height: 50,),
              TextButton(
                child: Text("Crear una nueva cuenta", style: TextStyle(fontSize: 18, color: Colors.black87),),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, "register"),
              )

            ],
          ),
        )
      )
    );
  }
}

class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginFormProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: "correo@dominio.com",
                labelText: "Correo",
                prefixIcon: Icons.alternate_email_sharp
              ),
              onChanged: (value) => loginFormProvider.email = value,
              validator: (value){
                
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? "") ? null : "El valor no luce como un correo@";

              },
            ),
            SizedBox(height: 30,),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: "*******",
                labelText: "Contraseña",
                prefixIcon: Icons.lock_outline
              ),
              onChanged: (value) => loginFormProvider.password = value,
              validator: (value){

                return value != null && value.length >= 6 ? null : "La contraseña debe ser igual o mayor a 6 caracteres";

              },
            ),
            SizedBox(height: 30,),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(loginFormProvider.isLoading ? "Espere" : "Ingresar", style: TextStyle(color: Colors.white),),
              ),
              onPressed: loginFormProvider.isLoading ? null : () async {
                
                FocusScope.of(context).unfocus();

                final authServices = Provider.of<AuthServices>(context, listen: false);

                if(!loginFormProvider.isValidForm()) return;

                loginFormProvider.isLoading = true;

                final String? errroMessage = await authServices.login(loginFormProvider.email, loginFormProvider.password);

                if(errroMessage == null) {
                  Navigator.pushReplacementNamed(context, "home");
                  
                }
                else {
                  print(errroMessage);
                  NotificationsServices.showSnackBar(errroMessage);
                  loginFormProvider.isLoading = false;
                }

              },
            )
          ],
        ),
      ),
    );
  }
}


