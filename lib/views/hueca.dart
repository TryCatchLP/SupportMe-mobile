import 'package:flutter/material.dart';
import 'package:supportme/theme/theme.dart';
import 'package:supportme/views/menu.dart';

class HuecaView extends StatefulWidget {
  @override
  _HuecaViewState createState() => _HuecaViewState();
}

class _HuecaViewState extends State<HuecaView> {
  final _formKey = GlobalKey<FormState>();
  bool _soydueno = false;
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
              ),
              CustomField(
                hintText: 'Dirección',
                icon: Icons.pin_drop,
              ),
              Row(children: [
                Expanded(
                  child: CustomField(
                    hintText: 'Latitude',
                  ),
                ),
                Container(
                  width: 10.0,
                ),
                Expanded(
                  child: CustomField(
                    hintText: 'Longitud',
                  ),
                ),
              ]),
              CustomField(
                hintText: 'Phone',
                icon: Icons.phone,
              ),
              SizedBox(height: 15.0),
              Card(
                  color: Colors.grey[350],
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 4,
                      decoration:
                          InputDecoration.collapsed(hintText: "Descripción"),
                    ),
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
                    // Process data.
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Menu()));
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

  CustomField({
    Key key,
    this.hintText,
    this.labelText,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText ?? hintText,
        suffixIcon: Icon(icon),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'Por favor ingrese su $hintText';
        }
        return null;
      },
    );
  }
}
