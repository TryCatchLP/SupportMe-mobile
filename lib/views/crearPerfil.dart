// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supportme/models/user.dart';
import 'package:supportme/auth/session.dart';

//void main() => runApp(CrearPerfilView());

class CrearPerfilView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CrearPerfil();
  }
}

class CrearPerfil extends StatefulWidget {
  CrearPerfilState createState() => CrearPerfilState();
}

class CrearPerfilState extends State<CrearPerfil> {
  CrearPerfilState({Key key}) : super();
  bool _obscureTextpass;
  bool _obscureTextpass2;
  final _claveFormulario = GlobalKey<FormState>();
  TextEditingController usernameCtrl = new TextEditingController();
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController apellidoCtrl = new TextEditingController();
  TextEditingController correoCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController telefonoCtrl = new TextEditingController();
  TextEditingController passCtrl = new TextEditingController();
  TextEditingController passCompCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _obscureTextpass = true;
    _obscureTextpass2 = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _submit() async {
    showDialog(
      context: context,
      child: Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    User user = User(
        username: usernameCtrl.text,
        firstname: nombreCtrl.text,
        lastname: apellidoCtrl.text,
        address: direccionCtrl.text,
        phone: telefonoCtrl.text,
        email: correoCtrl.text);

    final res = await Session.instance.profileCreated(user, passCtrl.text, passCompCtrl.text);
    Navigator.pop(context);

    if (res != false) {
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Usuario creado y logueado exitosamente!",
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Error al crear perfil!",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Cuenta"),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(children: <Widget>[
            SizedBox(height: 25.0),
            Container(
              child: Column(children: <Widget>[
                Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSzTRhI_GwJg_lQkMzDXcZlyOTyrSFCb3vY2A&usqp=CAU",
                    width: 70)
              ]),
            ),
            Form(
              key: _claveFormulario,
              child: ListView(shrinkWrap: true, children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 1, 60, 1),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese un nombre de usuario';
                      }
                      return null;
                    },
                    controller: usernameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Nombre de usuario',
                      labelText: 'Nombre de usuario',
                      suffixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 1, 60, 1),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    controller: correoCtrl,
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
                    controller: nombreCtrl,
                    textCapitalization: TextCapitalization.sentences,
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
                    controller: apellidoCtrl,
                    textCapitalization: TextCapitalization.sentences,
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
                    controller: telefonoCtrl,
                    decoration: InputDecoration(
                      hintText: 'Teléfono',
                      labelText: 'Teléfono',
                      suffixIcon: Icon(Icons.phone),
                    ),
                    maxLength: 10,
                    validator: validateMobile,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 1, 60, 1),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese su dirección';
                      }
                      return null;
                    },
                    controller: direccionCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Dirección',
                      labelText: 'Dirección',
                      suffixIcon: Icon(Icons.pin_drop),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 1, 60, 1),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese una contraseña';
                      } else if (value.length < 6)
                        return 'Contraseña muy corta.';
                      return null;
                    },
                    obscureText: _obscureTextpass,
                    controller: passCtrl,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      labelText: 'Contraseña',
                      suffixIcon: IconButton(
                        icon: _obscureTextpass
                            ? Icon(Icons.lock_outline)
                            : Icon(Icons.lock_open),
                        onPressed: () {
                          setState(() {
                            _obscureTextpass = !_obscureTextpass;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 1, 60, 8),
                  child: TextFormField(
                    obscureText: _obscureTextpass2,
                    validator: validatePassword,
                    controller: passCompCtrl,
                    decoration: InputDecoration(
                      hintText: 'Confirmar contraseña',
                      labelText: 'Confirmar contraseña',
                      suffixIcon: IconButton(
                        icon: _obscureTextpass2
                            ? Icon(Icons.lock_outline)
                            : Icon(Icons.lock_open),
                        onPressed: () {
                          setState(() {
                            _obscureTextpass2 = !_obscureTextpass2;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 8, 60, 8),
                  child: RaisedButton(
                    color: Color(0xFFF1D57F),
                    onPressed: () {
                      if (_claveFormulario.currentState.validate()) {
                        _submit();
                      }
                    },
                    child: Text('REGISTRARSE'),
                  ),
                ),
              ]),
            )
          ]),
        ],
      ),
    );
  }

  String validatePassword(String value) {
    if (value != passCtrl.text) {
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

String validateMobile(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "El telefono es necesario.";
  } else if (!regExp.hasMatch(value)) {
    return "Teléfono invalido.";
  } else if (value.length != 10) {
    return "El numero debe tener 10 digitos";
  }
  return null;
}
