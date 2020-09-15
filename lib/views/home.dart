import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supportme/auth/session.dart';
import 'package:supportme/views/hueca.dart';
import 'package:supportme/views/map_view.dart';
import 'package:supportme/views/profile.dart';
import 'buscar.dart';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomNavigationIndex = 0;
  Widget _widget;

  @override
  void initState() {
    _widget = MapView(
      onAddHueca: (latLng) => _onItemTap(2, latLng: latLng),
    );
    super.initState();
  }

  _onItemTap(int index, {LatLng latLng}) async {
    setState(() {
      if (index == 0 || index == 2 || (index == 3 && Session.instance.isAuthenticate)) _bottomNavigationIndex = index;
    });
    switch (index) {
      case 0:
        setState(() {
          _widget = MapView(
            onAddHueca: (latLng) => _onItemTap(2, latLng: latLng),
          );
        });
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => BuscarView()));
        break;
      case 2:
        setState(() {
          _widget = HuecaView();
        });
        break;
      case 3:
        if (Session.instance.isAuthenticate) {
          setState(() {
            _widget = ProfileView();
          });
        } else {
          bool login = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Login()));
          if(login ?? false){
            setState(() {
            _widget = ProfileView();
            });
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widget,
      bottomNavigationBar: BottomMenu(
        bottomNavigationIndex: _bottomNavigationIndex,
        onItemTap: _onItemTap,
      ),
    );
  }
}

class BottomMenu extends StatelessWidget {
  final Function(int) onItemTap;
  final int bottomNavigationIndex;

  const BottomMenu(
      {Key key, @required this.bottomNavigationIndex, this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: bottomNavigationIndex,
        onTap: onItemTap,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Inicio")),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text("Buscar")),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text("Nuevo")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Perfil"))
        ]);
  }
}
