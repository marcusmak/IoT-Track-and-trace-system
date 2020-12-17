import 'package:flutter/material.dart';

Widget inputWidget(BuildContext _context, String labelText, {TextEditingController controller, String Function(String) validator ,bool obscure = false}){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(_context).size.height * 0.05,
        vertical: MediaQuery.of(_context).size.height * 0.01,
      ),
      child:TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterStyle: TextStyle(
            fontSize:20,
            fontWeight: FontWeight.w500,
            color:Color.fromRGBO(225, 222, 210, 1)
          ),
          labelStyle: TextStyle(
            fontSize:20,
            fontWeight: FontWeight.w500,
            color:Color.fromRGBO(225, 222, 210, 1)
          ),
          labelText:  labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(width:1, color:Color.fromRGBO(225, 222, 210, 1)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(width: 1,)
          ),
          
        )
      )
    );
  }