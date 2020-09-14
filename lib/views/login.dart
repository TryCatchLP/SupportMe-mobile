import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supportme/auth/session.dart';
import 'package:supportme/theme/theme.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  IconData _password = Icons.lock;
  final _keyForm = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  _onShowPass() {
    setState(() {
      _password = _password == Icons.lock ? Icons.lock_open : Icons.lock;
    });
  }

  String _validate(String value) {
    return value.isEmpty ? "Campo obligatorio" : null;
  }

  _login() async {
    if (_keyForm.currentState.validate()) {
      showDialog(
          context: context,
          child: Center(
            child: CircularProgressIndicator(),
          ));
      String action = await Session.instance.login(email.text, password.text);
      if (action == "success") {
        Navigator.pop(context);
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: action, toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true, backgroundColor: Colors.transparent),
      body: Form(
        key: _keyForm,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
          children: [
            SafeArea(
              child: Image.asset(
                "assets/images/logo.png",
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            TextFormField(
              validator: _validate,
              controller: email,
              decoration: InputDecoration(
                  labelText: "Correo",
                  hintText: "Correo",
                  alignLabelWithHint: true,
                  suffixIcon: Icon(Icons.person_outline)),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              obscureText: _password == Icons.lock,
              validator: _validate,
              controller: password,
              decoration: InputDecoration(
                  labelText: "Contraseña",
                  hintText: "Contraseña",
                  alignLabelWithHint: true,
                  suffixIcon: IconButton(
                    icon: Icon(_password),
                    onPressed: _onShowPass,
                  )),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              onPressed: _login,
              color: AppTheme.primary,
              child: Text("INICIAR SESIÓN"),
            ),
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {},
              child: Text(
                "RECUPERAR CONTRASEÑA",
                style: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: RegisterSection(),
    );
  }
}

class RegisterSection extends StatelessWidget {
  const RegisterSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: Colors.black,
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("¿N0 TIENE UNA CUENTA?"),
              FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {},
                child: Text(
                  "REGISTRARSE",
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
