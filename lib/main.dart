import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.lightBlue[800], //主题色为蓝色
        ),
        home: MyHomePage(title: 'Custom UI'),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //使用控制Tabbar切换
  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.system_update), text: "组合"),
            Tab(icon: Icon(Icons.cake), text: "自绘")
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView(
            children: <Widget>[
              UpdatedItemWidget(
                model: UpdatedItemModel(
                    appIcon: "assets/icon.png",
                    appDescription:
                        "Thanks for using Google Maps! This release brings bug fixes that improve our product to help you discover new places and navigate to them.",
                    appName: "Google Maps - Transit & Fond",
                    appSize: "137.2",
                    appVersion: "Version 5.19",
                    appDate: "2019年6月5日"),
                onPressed: () {},
              )
            ],
          ),
          Center(child: Cake())
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class UpdatedItemModel {
  String appIcon;
  String appName;
  String appSize;
  String appDate;
  String appDescription;
  String appVersion;

  UpdatedItemModel(
      {this.appIcon,
      this.appName,
      this.appSize,
      this.appDate,
      this.appDescription,
      this.appVersion});
}

class UpdatedItemWidget extends StatefulWidget {
  final UpdatedItemModel model;

  UpdatedItemWidget({Key key, this.model, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  State<UpdatedItemWidget> createState() => _UpdatedItemWidgetState();
}

class _UpdatedItemWidgetState extends State<UpdatedItemWidget>
    with WidgetsBindingObserver {
  bool flag = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        flag = context.size.height > 40.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //组合上下两部分
    return Column(
        children: <Widget>[buildTopRow(context), buildBottomRow(context)]);
  }

  //创建上半部分
  Widget buildTopRow(BuildContext context) {
    return Row(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(widget.model.appIcon, width: 80, height: 80))),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.model.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, color: Color(0xFF8E8D92)),
            ),
            Text(
              "${widget.model.appDate}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, color: Color(0xFF8E8D92)),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: FlatButton(
          color: Color(0xFFF1F0F7),
          highlightColor: Colors.blue[700],
          colorBrightness: Brightness.dark,
          child: Text(
            "OPEN",
            style: TextStyle(
                color: Color(0xFF007AFE), fontWeight: FontWeight.bold),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: widget.onPressed,
        ),
      )
    ]);
  }

  //创建下半部分
  Widget buildBottomRow(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Stack(
          children: <Widget>[
            Text(
              widget.model.appDescription,
              style: TextStyle(fontSize: 14),
              maxLines: flag ? 2 : null,
            ),
            flag
                ? Positioned(
                    right: -5,
                    child: TextButton(
                      onPressed: () => setState(() {
                        flag = !flag;
                      }),
                      child: Container(
                        width: 60,
                        padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.white.withOpacity(.7),
                          Colors.white.withOpacity(1),
                          Colors.white.withOpacity(1),
                          Colors.white.withOpacity(1),
                        ])),
                        alignment: Alignment.center,
                        child: Text(
                          'more',
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 14),
                        ),
                      ),
                    ))
                : Container()
          ],
        ));
  }
}

class Cake extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200),
      painter: WheelPainter([5,4,3,6,8,1,2,9,10,7]),
    );
  }
}

class WheelPainter extends CustomPainter {
  List<double> _list;
  List<Color> _listColor = <Color>[
    Colors.orange,
    Colors.black38,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.pink,
  ];

  WheelPainter(this._list);

  //设置画笔颜色
  Paint getColoredPaint(Color color) {
    Paint paint = Paint();
    paint.color = color;
    return paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //饼图尺寸
    double _total = _list.reduce((value, element) => value + element);
    double wheelSize = min(size.width, size.height) / 2;
    double radius = (2 * pi) / _total;
    Rect boundingRect = Rect.fromCircle(
        center: Offset(wheelSize, wheelSize), radius: wheelSize);

    //画圆弧 i = -1 用于圆弧从 0位置开始
    for (var i = 0; i < _list.length; i++) {
      double startRadius = 0;
      if(i != 0){
        startRadius = _list.sublist(0,i).reduce((value, element) => value + element) * radius;
      }
      canvas.drawArc(
          boundingRect,
          startRadius,
          _list[i] * radius,
          true,
          getColoredPaint(_listColor[i % _listColor.length]));
    }
    // canvas.drawArc(boundingRect, _list[2] * radius, radius, true, getColoredPaint(Colors.black38));
    // canvas.drawArc(boundingRect, 0, radius, true, getColoredPaint(Colors.black38));
    // canvas.drawArc(boundingRect, radius, radius, true, getColoredPaint(Colors.black38));
    // canvas.drawArc(boundingRect, radius * 2, radius, true, getColoredPaint(Colors.green));
    // canvas.drawArc(boundingRect, radius * 3, radius, true, getColoredPaint(Colors.red));
    // canvas.drawArc(boundingRect, radius * 4, radius, true, getColoredPaint(Colors.blue));
    // canvas.drawArc(boundingRect, radius * 5, radius, true, getColoredPaint(Colors.pink));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
