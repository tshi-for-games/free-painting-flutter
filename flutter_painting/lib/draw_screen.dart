import 'package:flutter/material.dart';
import 'package:flutter_painting/mobile_canvas.dart';
import 'app_bar.dart';
class DrawScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,

        child: Column(
          children: <Widget>[
            // Bar
            Expanded(
              flex: 1,
              child: CustomAppBar(),
            ),
            
            Expanded(
              flex: 5,
              child: CanvasPainting(),
            ),
           
           
          ],
        ),

      ),
    );
  }
  

}