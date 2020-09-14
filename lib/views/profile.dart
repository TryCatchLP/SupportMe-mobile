import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  bool _activado;
  bool _obscureTextpass;
  bool _obscureTextpass2;

  @override
  void initState() {
    super.initState();
    _activado = false;
    _obscureTextpass = true;
    _obscureTextpass2 = true;

    nombreCtrl.text = "Steven";
    apellidoCtrl.text = "Araujo";
    correoCtrl.text = "steven@correo.com";
    passCtrl.text = "prueba123";
    passCtrl2.text = "prueba123";
  }

  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController apellidoCtrl = new TextEditingController();
  TextEditingController correoCtrl = new TextEditingController();
  TextEditingController passCtrl = new TextEditingController();
  TextEditingController passCtrl2 = new TextEditingController();

  String _validate(value) {
    if (value.isEmpty) return 'Campo vacío';
    return null;
  }

  String _validatePss(value) {
    if (value.length == 0)
      return 'Ingrese contraseña.';
    else if (value.length < 6)
      return 'Contraseña muy corta.';
    else if (passCtrl.text != passCtrl2.text)
      return 'No coinciden las contraseñas';
    return null;
  }

  _submit() async {
    showDialog(
        context: context,
        child: Center(
          child: CircularProgressIndicator(),
        ));
    /*
    Hueca hueca = Hueca(
        name: nombreCtrl.text,
        descrip: descripcionCtrl.text,
        lat: double.parse(latitudCtrl.text),
        lng: double.parse(longitudCtrl.text),
        address: direccionCtrl.text,
        photo: "C://",
        phone: telefonoCtrl.text,
        //schedule: horarioCtrl.text,
        stars: 0,
        ratings: 0);
  
    */

    Navigator.pop(context);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => MenuView(hueca: hueca)));
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _activado = !_activado;
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(40.0), children: <Widget>[
          CustomField(
            hintText: 'Nombre',
            icon: Icons.person_outline,
            mobileCtrl: nombreCtrl,
            validate: _validate,
            enabled: _activado,
          ),
          CustomField(
            hintText: 'Apellido',
            icon: Icons.person_outline,
            mobileCtrl: apellidoCtrl,
            validate: _validate,
            enabled: _activado,
          ),
          CustomField(
            hintText: 'Correo',
            icon: Icons.email,
            mobileCtrl: correoCtrl,
            validate: _validate,
            textInput: TextInputType.emailAddress,
            enabled: _activado,
          ),
          CustomField(
            hintText: 'Contraseña',
            mobileCtrl: passCtrl,
            validate: _validatePss,
            textInput: TextInputType.emailAddress,
            enabled: _activado,
            obscureText: _obscureTextpass,
            textCapitalization: TextCapitalization.none,
            iconButton: IconButton(
              icon: Icon(
                  _obscureTextpass ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureTextpass = !_obscureTextpass;
                });
              },
            ),
          ),
          CustomField(
            hintText: 'Comprobar contraseña',
            mobileCtrl: passCtrl2,
            validate: _validatePss,
            textInput: TextInputType.emailAddress,
            enabled: _activado,
            obscureText: _obscureTextpass2,
            textCapitalization: TextCapitalization.none,
            iconButton: IconButton(
              icon: Icon(
                  _obscureTextpass2 ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureTextpass2 = !_obscureTextpass2;
                });
              },
            ),
          ),
          SizedBox(height: 20.0),
          Opacity(
            opacity: _activado? 1.0: 0.0,
            child: RaisedButton(
              onPressed: _activado
                  ? () {
                      if (_formKey.currentState.validate()) {
                        _submit();
                        // Process data.
                      }
                    }
                  : null,
              child: Text('GUARDAR'),
            ),
          ),
          SizedBox(height: 130.0),
          FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _submit();
                // Process data.
              }
            },
            child: Row(
              children: [
                Icon(Icons.trending_up),
                Text('  CALIFICACIONES'),
              ],
            ),
          ),
          Divider(
            color: Colors.orangeAccent,
          ),
          FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _submit();
                // Process data.
              }
            },
            child: Row(
              children: [
                Icon(Icons.exit_to_app),
                Text('  CERRAR SESION'),
              ],
            ),
          ),
          Divider(
            color: Colors.orangeAccent,
          ),
        ]),
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mobileCtrl,
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
    );
  }
}
