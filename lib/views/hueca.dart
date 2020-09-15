import 'package:flutter/material.dart';
import 'package:supportme/models/hueca.dart';
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
  TextEditingController horarioCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
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
    Hueca hueca = Hueca(
        name: nombreCtrl.text,
        descrip: descripcionCtrl.text,
        schedule: horarioCtrl.text,
        lat: double.parse(latitudCtrl.text),
        lng: double.parse(longitudCtrl.text),
        address: direccionCtrl.text,
        photo: "C://",
        phone: telefonoCtrl.text,
        //schedule: horarioCtrl.text,
        stars: 0,
        ratings: 0);

    Navigator.pop(context);
    bool aceptado = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => MenuView(hueca: hueca)));

    if(aceptado != null){
      nombreCtrl.text = "";
      direccionCtrl.text = "";
      latitudCtrl.text = "";
      longitudCtrl.text = "";
      telefonoCtrl.text = "";
      descripcionCtrl.text = "";
      horarioCtrl.text = "";
    }
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
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(40.0),
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
                  textInput: TextInputType.number,
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
                  textInput: TextInputType.number,
                ),
              ),
            ]),
            CustomField(
              hintText: 'Horario',
              icon: Icons.schedule,
              mobileCtrl: horarioCtrl,
              validate: _validate,
            ),
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
            SizedBox(height: 20.0),
            Card(
                color: Colors.grey[350],
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: descripcionCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(hintText: "Descripción"),
                      validator: _validate,
                      textCapitalization: TextCapitalization.sentences,
                    ))),
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
    );
  }
}

class CustomField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData icon;
  final TextInputType textInput;
  final TextEditingController mobileCtrl;
  final Function(String) validate;
  final bool enabled;

  CustomField({
    Key key,
    this.enabled,
    this.hintText,
    this.labelText,
    this.icon,
    this.textInput,
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
        //prefix: CircularProgressIndicator(),
      ),
      keyboardType: textInput ?? TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      validator: validate,
      enabled: enabled ?? true,
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
