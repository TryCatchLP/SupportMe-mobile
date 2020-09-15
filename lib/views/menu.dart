import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List<Menu> listaMenu;

  @override
  void initState() {
    super.initState();
    listaMenu = [];
  }

  _submit() async {
    showDialog(
      context: context,
      child: Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    Hueca hueca = widget.hueca;

    final res = await HuecaService.post(hueca, listaMenu);
    if (res != null) {
      Navigator.pop(context);
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Error al crear la hueca",
      );
    }
  }

  _changeState(String value) {
    setState(() {});
  }

  Widget _builder(context, i) {
    return ExpansionTile(
      trailing: Icon(Icons.check),
      title: Text(listaMenu[i].title),
      children: [
        FormMenu(
          menu: listaMenu[i],
          changeState: _changeState,
        ),
      ],
    );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RaisedButton(
                    color: Colors.orangeAccent,
                    onPressed: () {
                      setState(() {
                        listaMenu.insert(
                            0,
                            Menu(
                              title: "",
                              ingredients: "",
                              price: 0.0,
                            ));
                      });
                    },
                    child: Text('+ AÑADIR'),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: listaMenu == null ? 0 : listaMenu.length,
                itemBuilder: _builder,
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
  final TextInputType textInput;
  final TextCapitalization textCapitalization;
  final TextEditingController mobileCtrl;
  final Function(String) validate;
  final bool enabled;
  final bool obscureText;
  final IconButton iconButton;
  final String initialValue;
  final onChanged;

  CustomField({
    Key key,
    this.enabled,
    this.hintText,
    this.labelText,
    this.icon,
    this.textInput,
    this.textCapitalization,
    this.mobileCtrl,
    this.validate,
    this.obscureText,
    this.iconButton,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mobileCtrl,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText ?? hintText,
        suffixIcon: iconButton ?? Icon(icon),
        //prefix: CircularProgressIndicator(),
      ),
      keyboardType: textInput ?? TextInputType.text,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      validator: validate,
      enabled: enabled ?? true,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
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
  final Menu menu;
  final changeState;

  FormMenu({
    Key key,
    this.menu,
    this.changeState,
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
            initialValue: menu.title,
            hintText: 'Nombre',
            validate: _validate,
            onChanged: (text) {
              changeState(text);
              menu.title = text;
            },
          ),
          SizedBox(height: 15.0),
          Card(
              color: Colors.grey[350],
              child: TextFormField(
                initialValue: menu.ingredients,
                onChanged: (text) {
                  menu.ingredients = text;
                },
                maxLines: 4,
                decoration: InputDecoration(hintText: "Ingredientes"),
                validator: _validate,
              )),
          SizedBox(height: 15.0),
          CustomField(
            onChanged: (text) {
              menu.price = double.parse(text);
            },
            hintText: 'Precio',
            textInput: TextInputType.phone,
            validate: validatePrice,
            initialValue: "${menu.price}",
          ),
          SizedBox(height: 25.0),
        ],
      ),
    );
  }
}
