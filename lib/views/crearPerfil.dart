// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

//void main() => runApp(MyApp());

class CrearPerfilView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perfil',
      theme: ThemeData(
        primaryIconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      home: CrearPerfil(),
    );
  }
}

class CrearPerfil extends StatefulWidget {
  CrearPerfilState createState() => CrearPerfilState();
}

class CrearPerfilState extends State<CrearPerfil> {
  CrearPerfilState({Key key}) : super();
  final _claveFormulario = GlobalKey<FormState>();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _apellido = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
  final TextEditingController _validarPass = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Crear Cuenta", style:(TextStyle(color: Colors.black))),
        backgroundColor: Colors.white,
        elevation: 0.7, 
      ),
      backgroundColor: Colors.white,
      body: Container(
      child: Column( children: <Widget>[
        SizedBox(height: 25.0),
        Container( child: Column( children:  <Widget>[
          Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSzTRhI_GwJg_lQkMzDXcZlyOTyrSFCb3vY2A&usqp=CAU", width: 70)
          ]),
        ),
        Form(
        key: _claveFormulario,
        child: ListView(shrinkWrap: true, children: <Widget>[
          
          Padding(
            padding: EdgeInsets.fromLTRB(60, 1, 60, 1),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator:validateEmail,
              controller: _correo,
              decoration: InputDecoration(
                hintText: 'Correo',
                labelText: 'Correo',
                suffixIcon: Icon(Icons.mail),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(60, 1, 60, 1),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese su nombre';
                }
                return null;
              },
              controller: _nombre,
              decoration: InputDecoration(
                hintText: 'Nombre',
                labelText: 'Nombre',
                suffixIcon: Icon(Icons.perm_identity),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(60, 1, 60, 1),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese su apellido';
                }
                return null;
              },
              controller: _apellido,
              decoration: InputDecoration(
                hintText: 'Apellido',
                labelText: 'Apellido',
                suffixIcon: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(60, 1, 60, 1),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese una contraseña';
                }
                return null;
              },
              obscureText: true,
              controller: _contrasena,
              decoration: InputDecoration(
                hintText: 'Contraseña',
                labelText: 'Contraseña',
                suffixIcon: Icon(Icons.lock),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(60, 1, 60, 8),
            child: TextFormField(
              obscureText: true,
              validator:validatePassword,
              controller: _validarPass,
              decoration: InputDecoration(
                hintText: 'Confirmar contraseña',
                labelText: 'Confirmar contraseña',
                suffixIcon: Icon(Icons.lock_open),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(60, 8, 60, 8),
            child: RaisedButton(
              color: Colors.amber,
              onPressed: () {
                if (_claveFormulario.currentState.validate()) {
                }
              },
              child: Text('REGISTRARSE'),
            ),),
        ]),
      )
      ])),
    );
  }
  String validatePassword(String value) {
   print("valorrr $value passsword ${_contrasena.text}");
   if (value != _contrasena.text) {
     return "Las contraseñas no coinciden";
   }
   return null;
 }
}

String validateEmail(String value) {
   String pattern =
       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
   RegExp regExp = new RegExp(pattern);
   if (value.length == 0) {
     return "El correo es necesario";
   } else if (!regExp.hasMatch(value)) {
     return "Correo invalido";
   } else {
     return null;
   }
 }
