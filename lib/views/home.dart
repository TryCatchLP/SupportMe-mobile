import 'package:flutter/material.dart';
import 'package:supportme/views/Rating.dart';
import 'package:supportme/views/hueca.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomNavigationIndex = 0;
  Widget _widget;

  @override
  void initState() {
    _widget = SafeArea(child: Text('Principal'));
    super.initState();
  }

  _onItemTap(int index) {
    setState(() {
      _bottomNavigationIndex = index;
    });
    switch (index) {
      case 0:
        setState(() {
          _widget = SafeArea(child: Text('Principal'));
        });
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RatingView()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HuecaView()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widget,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.gps_fixed,
          color: Color(0xFF59A5BD),
        ),
        onPressed: () => {},
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text("Nuevo")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Perfil"))
        ]);
  }
}
