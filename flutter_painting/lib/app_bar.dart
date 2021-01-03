import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(width: 10,),
          SizedBox(width: 10,),
          IconHover(),
        ],
      ),
    );
  }
}

class IconHover extends StatefulWidget {
  @override
  _IconHoverState createState() => _IconHoverState();
}

class _IconHoverState extends State<IconHover> with TickerProviderStateMixin{
  Color iconColor = Colors.green;

  @override
  Widget build(context) {
    return InkWell(  
      onTap: (){
      },
      onHover: (value){
        if(value){
          setState((){  
            iconColor = Colors.lightGreen;
          });
        }else{
          setState((){
            iconColor = Colors.green;
          });
        }
      },
      child: Icon(
        Icons.clear,
        color: iconColor,
        size: 40,
      ),
    );
  }
}