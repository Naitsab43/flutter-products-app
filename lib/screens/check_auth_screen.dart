import 'package:flutter/material.dart';
import 'package:products_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'package:products_app/screens/login_screen.dart';
import 'package:products_app/services/auth_services.dart';


class CheckAuthScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authServices.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

            if(!snapshot.hasData){
              return Text('');
            }

            if(snapshot.data == ""){

              Future.microtask((){

                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) => LoginScreen(),
                  transitionDuration: Duration(seconds: 0)
                ));


              });

            }

            else {

              Future.microtask((){

                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_, __, ___) => HomeScreen(),
                  transitionDuration: Duration(seconds: 0)
                ));


              });


            }

            
            
            return Container();

          },
        ),
      ),
    );
  }
}