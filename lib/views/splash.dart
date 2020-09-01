import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supportme/theme/theme.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset("assets/images/logo.png"),
            SizedBox(height: 10,),
            Text("SupportMe", style: 
              GoogleFonts.rakkas(fontSize: 35, color: Colors.white, 
              decoration: TextDecoration.none,))
          ],
        ),
      ), 
    );
  }
}