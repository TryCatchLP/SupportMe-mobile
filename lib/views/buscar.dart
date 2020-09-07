// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buscar',
      theme: ThemeData(
        
        primaryIconTheme: IconThemeData(
    color: Colors.black,
  )
      ),
      home: Buscar(),
    );
  }
}

class Buscar extends StatefulWidget {
  final List<String> list = null;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Buscar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: PrimaryColor,
        actions: <Widget>[
         IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Search(widget.list));
            },
            icon: Icon(Icons.search),
          ),
        ],
        centerTitle: false,
        title: Text('Buscar', style:(TextStyle(color: Color(0xFFC4C4C4)))),
        backgroundColor: Colors.white,
        elevation: 0.7,    
      ),
      body: vista(),
      bottomNavigationBar: BottomNavigationBar(
        
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
        ],
        ),
    );
     
  }
}
Widget vista() {
     return Container(
      child: Column(
         children: <Widget>[
           Container(
            child:Row(
              children:  <Widget>[
                SizedBox(height: 40.0),
                SizedBox(width: 20.0),
                Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQCwoP17v-18qx6u_le4xC0Njb98HbCJ5ZT6w&usqp=CAU", width: 15),
                SizedBox(width: 10.0),
                Text("Filtrar", style: TextStyle(fontWeight: FontWeight.bold)),
              ]
            )
          ),
        Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
          decoration:BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.red, width: 1.0,)),
          ),
          
            child:Row(
              children:  <Widget>[
                Text("RECOMENDACIONES", style:(TextStyle(color: Colors.red, fontSize: 15))),
              ]
            )
          ),
          Column(
           children: <Widget> [
           //SizedBox(width: 150.0), 
             Container(
             //color: Colors.amber,
             //width: 80.0,
             //height: 15.0,
             margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
             decoration:BoxDecoration(
               color: Color(0xFFF1D57F),
              border: Border.all(color: Color(0xFFF1D57F),width: 1.0,),
              ),
            
            child:Row(
              children:  <Widget>[
                SizedBox(height: 25.0),
                SizedBox(width: 12.0), 
                Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSnekR0L0HHNjpeva06BBuq1oH44lplGESXNQ&usqp=CAU", width: 70),
                SizedBox(width: 10.0),
                Text("Hueca 1\nRestaurante\nAbierto\nLunes-Viernes: 07:30-16:00\nSábado: 8:00-15:00", style: TextStyle(fontWeight: FontWeight.bold, fontSize:11)),
              ]
            )
          ),
          Container(
             //width: 80.0,
             //height: 15.0,
             margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
             decoration:BoxDecoration(
               color: Color(0xFFF1D57F),
              border: Border.all(color: Color(0xFFF1D57F),width: 1.0,),
              ),
            
            child:Row(
             
              children:  <Widget>[
                SizedBox(height: 25.0),
                SizedBox(width: 12.0), 
               Image.network("https://res.cloudinary.com/civico/image/upload/c_fit,f_auto,fl_lossy,h_1200,q_auto:low,w_1200/v1517429789/entity/image/file/107/000/5a72241c658d1de180000107.jpg", width: 70),
                SizedBox(width: 10.0),
                Text("Hueca 2\nRestaurante\nAbierto\nLunes-Viernes: 07:30-16:00\nSábado: 8:00-15:00", style: TextStyle(fontWeight: FontWeight.bold, fontSize:11)),
              ]
            )
          ),
          Container(
             //width: 80.0,
             //height: 150.0,
             margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
             decoration:BoxDecoration(
               color: Color(0xFFF1D57F),
               border: Border.all(color: Color(0xFFF1D57F),width: 1.0,),
              ),
            
            child:Row(
              children:  <Widget>[
                SizedBox(height: 25.0),
                SizedBox(width: 12.0), 
                Image.network("https://www.eluniverso.com/sites/default/files/styles/powgallery_1024/public/fotos/2018/07/data252280170000.jpg?itok=uRt2CnLI", width: 70),
                SizedBox(width: 10.0),
                Text("Hueca 3\nRestaurante\nAbierto\nLunes-Viernes: 07:30-16:00\nSábado: 8:00-15:00",style: TextStyle(fontWeight: FontWeight.bold, fontSize:11)),
              ]
            )
          ),
        ],
      ),
           
           
        
        ])
      
    );
}

class Search extends SearchDelegate {
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
        close(context,null);
      },
    );
  }

  String selectedResult = " ";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<String> listExample;
  Search(this.listExample);

  List<String> recentList = ["Menu", "Menu 1"];

  @override
  Widget buildSuggestions(BuildContext context) {
     return Column();
  }
}