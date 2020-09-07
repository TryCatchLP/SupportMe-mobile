import 'package:flutter/material.dart';
import 'package:supportme/main.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/models/menu.dart';
import 'package:supportme/services/hueca_service.dart';
import 'package:supportme/theme/theme.dart';

class MenuView extends StatefulWidget {
  final Hueca hueca;

  MenuView({
    Key key,
    this.hueca,
  }) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController priceCtrl = new TextEditingController();
  TextEditingController ingredintesCtrl = new TextEditingController();
  TextEditingController nombreCtrl2 = new TextEditingController();
  TextEditingController priceCtrl2 = new TextEditingController();
  TextEditingController ingredintesCtrl2 = new TextEditingController();

  _submit() async {
    showDialog(
        context: context,
        child: Center(
          child: CircularProgressIndicator(),
        ));

    Hueca hueca = widget.hueca;
    Menu menu = Menu(
      title: nombreCtrl.text, 
      ingredients: ingredintesCtrl.text,
      price: double.parse(priceCtrl.text),
    );
    Menu menu2 = Menu(
      title: nombreCtrl2.text, 
      ingredients: ingredintesCtrl2.text,
      price: double.parse(priceCtrl2.text),
    );

    final res = await HuecaService.post(hueca, [menu, menu2]);
    if (res != null) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Menú'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              FormMenu(
                nombreCtrl: nombreCtrl,
                priceCtrl: priceCtrl,
                ingredintesCtrl: ingredintesCtrl,
              ),
              SizedBox(height: 25.0),
              const Divider(
                color: Colors.black,
                height: 10,
                thickness: 3,
                indent: 0,
                endIndent: 0,
              ),
              SizedBox(height: 25.0),
              FormMenu(
                nombreCtrl: nombreCtrl2,
                priceCtrl: priceCtrl2,
                ingredintesCtrl: ingredintesCtrl2,
              ),
              SizedBox(height: 25.0),
              RaisedButton(
                color: AppTheme.primary,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _submit();
                    // Process data.
                  }
                },
                child: Text('REGISTRAR'),
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

String validatePrice(String value) {
  String pattern = r'(^[0-9]*[.]{0,1}[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "El precio es necesario.";
  } else if (!regExp.hasMatch(value)) {
    return "Teléfono invalido.";
  }
  return null;
}

class FormMenu extends StatelessWidget {
  final TextEditingController nombreCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController ingredintesCtrl;

  FormMenu({
    Key key,
    this.nombreCtrl,
    this.priceCtrl,
    this.ingredintesCtrl,
  }) : super(key: key);

  String _validate(value) {
    if (value.isEmpty) {
      return 'Campo vacío';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CustomField(
            hintText: 'Nombre',
            mobileCtrl: nombreCtrl,
            validate: _validate,
          ),
          SizedBox(height: 15.0),
          Card(
              color: Colors.grey[350],
              child: TextFormField(
                controller: ingredintesCtrl,
                maxLines: 4,
                decoration: InputDecoration(hintText: "Ingredientes"),
                validator: _validate,
              )),
          SizedBox(height: 15.0),
          TextFormField(
              controller: priceCtrl,
              decoration: InputDecoration(
                hintText: 'Precio',
                labelText: 'Precio',
              ),
              keyboardType: TextInputType.phone,
              validator: validatePrice),
          SizedBox(height: 25.0),
        ],
      ),
    );
  }
}
