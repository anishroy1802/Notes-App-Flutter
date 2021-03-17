//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

TextEditingController searchBarController = TextEditingController();
TextEditingController drawingNameInputController = TextEditingController();
List<String> drawingListNames = [];
List<String> newDrawingListNames = [];

List<DrawingScreen> drawingScreens = [];

class DrawingHomeScreen extends StatefulWidget {
  @override
  _DrawingHomeScreenState createState() => _DrawingHomeScreenState();
}

// saveData() async{
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   preferences.
// }

//DrawingHomeScreen is a modification of the earlier TodoListScreen
class _DrawingHomeScreenState extends State<DrawingHomeScreen> {
  void filterList(String key) {
    setState(() {
      if (key != null) {
        newDrawingListNames =
            drawingListNames.where((i) => i.contains(key)).toList();
      } else {
        newDrawingListNames = drawingListNames.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Flutter Assignment'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              height: 40,
              child: TextField(
                decoration: new InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),

                controller: searchBarController,
                onChanged: (String newText) {
                  filterList(newText);
                },
                //Search Bar
              )),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: newDrawingListNames.length,
            itemBuilder: (context, int index) {
              return new Dismissible(
                key: UniqueKey(),
                child: ListTile(
                  title: Text(newDrawingListNames[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => drawingScreens[index]),
                    );
                  },
                ),
                onDismissed: (direction) {
                  newDrawingListNames.removeAt(index);
                  newDrawingListNames.removeAt(index);
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add",
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Enter drawing name"),
                      content: TextField(
                        controller: drawingNameInputController,
                      ),
                      actions: <Widget>[
                        MaterialButton(
                            elevation: 5.0,
                            child: Icon(Icons.check),
                            onPressed: () {
                              setState(() {
                                drawingListNames.add(
                                  drawingNameInputController.text,
                                );
                                drawingScreens.add(
                                  new DrawingScreen(),
                                );
                              });
                              drawingNameInputController.text = "";
                              Navigator.of(context).pop();
                            }),
                        MaterialButton(
                            elevation: 5.0,
                            child: Icon(Icons.cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                              drawingNameInputController.text = "";
                            })
                      ]);
                });
          }),
    );
  }
}

//DrawingScreen is our new panel where we give our signatures
class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: new GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox object = context.findRenderObject();
              Offset _localPosition =
                  object.globalToLocal(details.globalPosition);
              _points = new List.from(_points)..add(_localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) => _points.add(null),
          child: new CustomPaint(
            painter: new Signature(points: _points),
            size: Size.infinite,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: new Icon(Icons.clear),
          onPressed: () {
            _points.clear();
          }),
    );
  }
}

class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint();
    paint.color = Colors.black;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) {
    return oldDelegate.points != points;
  }
}
