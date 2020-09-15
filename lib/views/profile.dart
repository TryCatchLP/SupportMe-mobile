import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supportme/auth/session.dart';
import 'package:supportme/models/user.dart';
import 'package:supportme/views/user_ratings.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  bool _activado;
  //bool _obscureTextpass;
  //bool _obscureTextpass2;
  TextEditingController idCtrl = new TextEditingController();
  TextEditingController usernameCtrl = new TextEditingController();
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController apellidoCtrl = new TextEditingController();
  TextEditingController correoCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController telefonoCtrl = new TextEditingController();

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => showDialog(
            barrierDismissible: false,
            context: context,
            child: Center(child: CircularProgressIndicator())));

    Session.instance.profile().then((value) {
      
      setState(
          () => {
            idCtrl.text = value.id.toString(),
            usernameCtrl.text = value.username,
            nombreCtrl.text = value.firstname,
            apellidoCtrl.text = value.lastname,
            direccionCtrl.text = value.address,
            telefonoCtrl.text = value.phone,
            correoCtrl.text = value.email,
          }); //hay que hacer un cambio de estado con el then
      Navigator.pop(context);
    });

    super.initState();
    _activado = false;
    //_obscureTextpass = true;
    //_obscureTextpass2 = true;
  }

  String _validate(value) {
    if (value.isEmpty) return 'Campo vacío';
    return null;
  }

/*
  String _validatePss(value) {
    if (value.length == 0)
      return 'Ingrese contraseña.';
    else if (value.length < 6)
      return 'Contraseña muy corta.';
    else if (passCtrl.text != passCtrl2.text)
      return 'No coinciden las contraseñas';
    return null;
  }
*/

  _submit() async {
    showDialog(
      context: context,
      child: Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    ) ;

    User user = User(
      id: int.tryParse(idCtrl.text),//Ya no es necesario
      username: usernameCtrl.text,
      firstname: nombreCtrl.text,
      lastname: apellidoCtrl.text,
      address: direccionCtrl.text,
      phone: telefonoCtrl.text,
      email: correoCtrl.text
    );
    final res = await Session.instance.profileUpdate(user);
    Navigator.pop(context);
    setState(() {
      _activado = !_activado;
    });

    if (res != false) {  
      Fluttertoast.showToast(
        msg: "Perfil actualizado exitosamente!",
      );
    } else {
      Fluttertoast.showToast(
        msg: "Error al actualizar perfil!",
      );
    }
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
            mobileCtrl: nombreCtrl,
            icon: Icons.person_outline,
            validate: _validate,
            enabled: _activado,
          ),
          CustomField(
            hintText: 'Apellido',
            mobileCtrl: apellidoCtrl,
            icon: Icons.person_outline,
            validate: _validate,
            enabled: _activado,
          ),
          CustomField(
            hintText: 'Correo',
            icon: Icons.email,
            mobileCtrl: correoCtrl,
            validate: validateEmail,
            textInput: TextInputType.emailAddress,
            enabled: _activado,
          ),
          CustomField(
            hintText: 'Direccion',
            icon: Icons.pin_drop,
            mobileCtrl: direccionCtrl,
            validate: _validate,
            enabled: _activado,
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
            enabled: _activado,
          ),
          SizedBox(height: 20.0),
          Opacity(
            opacity: _activado ? 1.0 : 0.0,
            child: RaisedButton(
              onPressed: _activado
                  ? () {
                      if (_formKey.currentState.validate()) {
                        _submit();
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserRatingsView(),
                    ));
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