import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'color_box.dart';

class CanvasPainting extends StatefulWidget {
  @override
  _CanvasPaintingState createState() => _CanvasPaintingState();
}

class _CanvasPaintingState extends State<CanvasPainting> {
  List<Path> _paths = <Path>[];
  List<Paint> _paint = <Paint>[];

  Path _path = new Path();
  bool _repaint = false;
  int back = 0;
  double _strokeWidth = 20;

  GlobalKey globalKey = GlobalKey();
  Color activeColor= Colors.black;

  _CanvasPaintingState(){
    _paths = [new Path()];

     Paint paint = new Paint()
    ..color = activeColor
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round
    ..strokeWidth = _strokeWidth;
    _paint.add(paint);
  }
  panDown(DragDownDetails details) {
    setState(() {
      _path = new Path();
      _paths.add(_path);
      RenderBox object = context.findRenderObject();
      Offset _localPosition = object.globalToLocal(details.globalPosition);
      _paths.last.moveTo(_localPosition.dx-10, _localPosition.dy-5);
      _paths.last.lineTo(_localPosition.dx-10, _localPosition.dy-5);
      
       Paint paint = new Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;
      _paint.add(paint);

      _repaint = true;
    });
  }

  var fingerPostionY = 0.0,fingerPostionX = 0.0;
  double distanceBetweenTwoPoints(double x1,double y1 ,double x2, double y2){
    double x = x1 - x2;
           x = x * x; 
    double y = y1 - y2;
           y = y * y;

    double result = x + y;
    return sqrt(result);
  }

  panUpdate(DragUpdateDetails details) {
    RenderBox object = context.findRenderObject();
      Offset _localPosition = object.globalToLocal(details.globalPosition);

     if (fingerPostionY < 1.0){
              // assigen for the first time to compare
              fingerPostionY = _localPosition.dy;
              fingerPostionX = _localPosition.dx;
            }else{
              // they use a lot of fingers
              double distance = distanceBetweenTwoPoints(_localPosition.dx,_localPosition.dy,
                                                    fingerPostionX,fingerPostionY);
              
              // the distance between two fingers must be above 50
              // to disable multi touch
              if(distance > 50){
                return;
              }
            }

            // update to use it in comparison
            fingerPostionY = _localPosition.dy;
            fingerPostionX = _localPosition.dx;

    setState(() {
      _paths.last.lineTo(fingerPostionX-10.0, fingerPostionY-5.0);
    });
  }

  panEnd(DragEndDetails details) {
    setState(() {
      fingerPostionY = 0.0;
//      _repaint = true;
    });
  }

  reset(){
    setState(() {
      eraserSound();
      _path = new Path();
      _paths = [new Path()];
      _paint = [new Paint()];
      _repaint = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Scaffold(
          backgroundColor: Colors.white,
          body: new GestureDetector(
            onPanDown: (DragDownDetails details) => panDown(details),
            onPanUpdate: (DragUpdateDetails details) => panUpdate(details),
            onPanEnd: (DragEndDetails details) => panEnd(details),
            child: RepaintBoundary(
            key: globalKey,
            child: Stack(
              children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/1.png",
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      colorBlendMode: BlendMode.modulate,
                      fit: BoxFit.fill,
                    ),
                  ),
              ),
                CustomPaint(
                  painter: new PathPainter(paths: _paths, repaint: _repaint, paints: _paint),
				          size: Size.infinite,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ColorBoxGroup(
                      width: 39,
                      height: 39,
                      spacing: 10.0,
                      colors: [
                        Colors.red,
                        Colors.orange,
                        Colors.green,
                        Colors.purple,
                        Colors.blue,
                        Colors.yellow,
                      ],
                      groupValue: activeColor,
                      onTap: (color) {
                        setState(() {
                          onChangeColor(color);
                          changeColorSound();
                        });
                      }
                    ),
                ),
              ],
            ),
          ),
      ),

      bottomNavigationBar: new Container(
        height: 30.0,
        margin: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        child: new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0),
                    child:Slider(
                        value: _strokeWidth,
                        min: 10,
                        max: 50,
                        divisions: 4,
                        label: _strokeWidth.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _strokeWidth = value;
                          });
                        },
                    ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
      ),

      floatingActionButton:  Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(left: 30.0),
            child:FloatingActionButton( 
            child: Image.asset("assets/images/eraser.png"), 
            backgroundColor: Colors.lightGreen, 
            onPressed: () {
              reset();
            }, 
          ),
        ),
    ),
    );
  }

  void onChangeColor(Color value) {
    activeColor = value;
  }

  var audioPath;
  void changeColorSound(){
    audioPath = "sounds/effects/select color.mp3";
  }

  void eraserSound(){
    audioPath = "sounds/effects/wipe.mp3";
  }

}

class PathPainter extends CustomPainter {
  List<Path> paths;
  List<Paint> paints;
  bool repaint;
  int i = 0;
  PathPainter({this.paths, this.repaint, this.paints});
  @override
  void paint(Canvas canvas, Size size) {
   
    paths.forEach((path){
      canvas.drawPath(path, paints[i]);
      ++i;
    });
   
    i = 0;
    repaint = false;
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => repaint;
}