import 'package:flutter/material.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/models/menu.dart';
import 'package:supportme/services/hueca_service.dart';
import 'package:supportme/theme/theme.dart';
import 'package:supportme/views/menu.dart';

class HuecaView extends StatefulWidget {
  @override
  _HuecaViewState createState() => _HuecaViewState();
}

class _HuecaViewState extends State<HuecaView> {
  final _formKey = GlobalKey<FormState>();
  bool _soydueno = false;

  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController latitudCtrl = new TextEditingController();
  TextEditingController longitudCtrl = new TextEditingController();
  TextEditingController telefonoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  //with SingleTickerProviderStateMixin {
  //AnimationController _controller;

  @override
  void initState() {
    super.initState();
    //_controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }

  _submit() async {
    showDialog(
        context: context,
        child: Center(
          child: CircularProgressIndicator(),
        ));
    Hueca hueca = Hueca(
        name: nombreCtrl.text,
        descrip: descripcionCtrl.text,
        lat: double.parse(latitudCtrl.text),
        lng: double.parse(longitudCtrl.text),
        address: direccionCtrl.text,
        photo: "C://",
        phone: telefonoCtrl.text,
        stars: 0,
        ratings: 0);
  

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuView(hueca: hueca)));
  }

  String _validate(value) {
    if (value.isEmpty) {
      return 'Campo vacío';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Hueca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              CustomField(
                hintText: 'Nombre',
                icon: Icons.person_outline,
                mobileCtrl: nombreCtrl,
                validate: _validate,
              ),
              CustomField(
                hintText: 'Dirección',
                icon: Icons.pin_drop,
                mobileCtrl: direccionCtrl,
                validate: _validate,
              ),
              Row(children: [
                Expanded(
                  child: CustomField(
                    hintText: 'Latitude',
                    mobileCtrl: latitudCtrl,
                    validate: validateCoord,
                  ),
                ),
                Container(
                  width: 10.0,
                ),
                Expanded(
                  child: CustomField(
                    hintText: 'Longitud',
                    mobileCtrl: longitudCtrl,
                    validate: validateCoord,
                  ),
                ),
              ]),
              TextFormField(
                controller: telefonoCtrl,
                decoration: InputDecoration(
                  hintText: 'Teléfono',
                  labelText: 'Teléfono',
                  suffixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: validateMobile,
              ),
              SizedBox(height: 15.0),
              Card(
                  color: Colors.grey[350],
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: descripcionCtrl,
                      maxLines: 4,
                      decoration: InputDecoration( hintText: "Descripción" ),
                      validator: _validate,
                    )
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: _soydueno,
                    onChanged: (bool value) {
                      setState(() {
                        _soydueno = value;
                      });
                    },
                  ),
                  Text("SOY DUEÑO"),
                ],
              ),
              SizedBox(height: 15.0),
              RaisedButton(
                color: AppTheme.primary,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _submit();
                    // Process data.
                  }
                },
                child: Text('SIGUIENTE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData icon;
  final TextEditingController mobileCtrl;
  final Function(String) validate;

  CustomField({
    Key key,
    this.hintText,
    this.labelText,
    this.icon,
    this.mobileCtrl,
    this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mobileCtrl,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText ?? hintText,
        suffixIcon: Icon(icon),
      ),
      keyboardType: TextInputType.text,
      validator: validate,
    );
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

String validateCoord(String value) {
  String pattern = r'(^[\-]{0,1}[0-9]*[.]{0,1}[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Campo vacío.";
  } else if (!regExp.hasMatch(value)) {
    return "Valores invalidos";
  }
  return null;
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
