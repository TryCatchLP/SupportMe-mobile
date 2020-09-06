import 'package:flutter/material.dart';

class Hueca extends StatefulWidget {
  @override
  _HuecaState createState() => _HuecaState();
}

class _HuecaState extends State<Hueca> {
  final _formKey = GlobalKey<FormState>();
  bool soy_dueno = false;
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
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Nombre',
                labelText: 'Nombre*',
                suffixIcon: Icon(Icons.person_outline),
              ),
              autofocus: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Dirección',
                labelText: 'Dirección*',
                suffixIcon: Icon(Icons.pin_drop),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor ingrese una dirección';
                }
                return null;
              },
            ),
            TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Longitude',
                    labelText: 'Longitude',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese una dirección';
                    }
                    return null;
                  },
                ),
            TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Latitude',
                    labelText: 'Latitude',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese una dirección';
                    }
                    return null;
                  },
                ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Phone',
                labelText: 'Phone',
                suffixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Por favor ingrese una dirección';
                }
                return null;
              },
            ),           

            Card(
              color: Colors.grey[350],
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 4,
                  decoration: InputDecoration.collapsed(hintText: "Descripción"),
                ),
              )
            ),

           Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: soy_dueno,
                    onChanged: (bool value) {
                      setState(() {
                        soy_dueno = value;
                      });
                    },
                  ),
                  Text("SOY DUEÑO"),
                ],
              ),

            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
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
