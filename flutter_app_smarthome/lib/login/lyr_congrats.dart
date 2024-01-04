import 'package:flutter/material.dart';
import 'package:flutter_app_smarthome/login/login.dart';
import 'package:flutter_app_smarthome/login/login.dart';
import 'package:flutter_app_smarthome/login/lyr_register.dart';

class LayarCongrats extends StatefulWidget {
  const LayarCongrats({super.key});

  @override
  State<LayarCongrats> createState() => _LayarCongratsState();
}

class _LayarCongratsState extends State<LayarCongrats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 233,194),
      body: ListView(
        children: [
          SizedBox(
            height: 300,),
            Text("Congratulations, \n You have Successfully Registered",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            ),
         SizedBox(height: 20,),
         Center(
          child: Text("Please return to Login",
          style: TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey),
          )), SizedBox(height: 10,),
          Center(
            child: Column(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed:(){
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 18, 210, 79),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      )),),
            ),
            SizedBox(height: 10,),
            GestureDetector(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage() ));
            },)           
            ]),
          )    

        ],
      )
    );
  }
}