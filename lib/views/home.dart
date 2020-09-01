import 'package:flutter/material.dart';
import 'package:supportme/theme/theme.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: AppTheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        
      ),
    );
  }
}
