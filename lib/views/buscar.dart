// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/services/hueca_service.dart';

class BuscarView extends StatelessWidget {
  final Function(Hueca hueca) onClose;

  const BuscarView({Key key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Buscar(
      onClose: onClose
    );
  }
}

class Buscar extends StatefulWidget {
  final List<String> list = null;
  final Function(Hueca hueca) onClose;

  const Buscar({Key key, this.onClose}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Buscar> {
  List<Hueca> huecas = List();
  @override
  void initState() {
    HuecaService.getHuecas().then((List<Hueca> values) {
      setState(() {
        huecas = values;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: PrimaryColor,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              Hueca hueca =
                  await showSearch(context: context, delegate: Search());
              this.widget.onClose(hueca);
            },
            icon: Icon(Icons.search),
          ),
        ],
        centerTitle: false,
        title: Text('Buscar', style: (TextStyle(color: Color(0xFFC4C4C4)))),
        backgroundColor: Colors.white,
        elevation: 0.7,
      ),
      body: Container(
        child: Column(children: <Widget>[
          Container(
              child: Row(children: <Widget>[
            SizedBox(height: 40.0),
            SizedBox(width: 20.0),
            Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQCwoP17v-18qx6u_le4xC0Njb98HbCJ5ZT6w&usqp=CAU",
                width: 15),
            SizedBox(width: 10.0),
            Text("Filtrar", style: TextStyle(fontWeight: FontWeight.bold)),
          ])),
          Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                )),
              ),
              child: Row(children: <Widget>[
                Text("RECOMENDACIONES",
                    style: (TextStyle(color: Colors.red, fontSize: 15))),
              ])),
          Expanded(
            child: ListView.builder(
              itemBuilder: _builder,
              itemCount: huecas.length,
            ),
          )
        ]),
      ),
    );
  }

  Widget _builder(context, i) {
    return Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
        decoration: BoxDecoration(
          color: Color(0xFFF1D57F),
          border: Border.all(
            color: Color(0xFFF1D57F),
            width: 1.0,
          ),
        ),
        child: Row(children: <Widget>[
          SizedBox(height: 25.0),
          SizedBox(width: 12.0),
          FadeInImage(
            placeholder: AssetImage("assets/images/bg.jpg"),
            image: NetworkImage(
                huecas[i]?.photo != null && huecas[i]?.photo != "C://"
                    ? "http://localhost:8000/${huecas[i]?.photo}"
                    : "https://pbs.twimg.com/media/D38wwCmW4AEp8lo.jpg"),
            width: 70,
          ),
          SizedBox(width: 10.0),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5),
            child: Text(
                "${huecas[i].name}\n${huecas[i].descrip}\nAbierto\n${huecas[i].schedule}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ]));
  }

  Widget vista() {
    return Container(
        child: Column(children: <Widget>[
      Container(
          child: Row(children: <Widget>[
        SizedBox(height: 40.0),
        SizedBox(width: 20.0),
        Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQCwoP17v-18qx6u_le4xC0Njb98HbCJ5ZT6w&usqp=CAU",
            width: 15),
        SizedBox(width: 10.0),
        Text("Filtrar", style: TextStyle(fontWeight: FontWeight.bold)),
      ])),
      Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
              color: Colors.red,
              width: 1.0,
            )),
          ),
          child: Row(children: <Widget>[
            Text("RECOMENDACIONES",
                style: (TextStyle(color: Colors.red, fontSize: 15))),
          ])),
    ]));
  }
}

class Search extends SearchDelegate<Hueca> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  String selectedResult = " ";

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length == 0) {
      return Text("Sin resultados");
    }

    return FutureBuilder(
        future: HuecaService.getHuecas(query: this.query),
        builder: (context, AsyncSnapshot<List<Hueca>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _showResults(snapshot.data);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _showResults(List<Hueca> huecas) {
    return ListView.builder(
        itemBuilder: (c, i) => _builder(c, huecas[i]),
        itemCount: huecas.length);
  }

  Widget _builder(BuildContext context, Hueca hueca) {
    return GestureDetector(
      onTap: () {
        close(context, hueca);
      },
      child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
          decoration: BoxDecoration(
            color: Color(0xFFF1D57F),
            border: Border.all(
              color: Color(0xFFF1D57F),
              width: 1.0,
            ),
          ),
          child: Row(children: <Widget>[
            SizedBox(height: 25.0),
            SizedBox(width: 12.0),
            FadeInImage(
              placeholder: AssetImage("assets/images/bg.jpg"),
              image: NetworkImage(hueca?.photo != null && hueca?.photo != "C://"
                  ? "http://localhost:8000/${hueca?.photo}"
                  : "https://pbs.twimg.com/media/D38wwCmW4AEp8lo.jpg"),
              width: 70,
            ),
            SizedBox(width: 10.0),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5),
              child: Text(
                  "${hueca.name}\n${hueca.descrip}\nAbierto\n${hueca.schedule}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ])),
    );
  }

  Search();

  List<String> recentList = ["Menu", "Menu 1"];

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListTile(
      title: Text("Suggestions"),
    );
  }
}
