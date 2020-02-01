import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Performance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
          ],
        ),
      ),
    );
  }
}

class AnimatedWidget extends StatefulWidget{
  @override
  AnimatedWidgetState createState() => AnimatedWidgetState();
}

class AnimatedWidgetState extends State<AnimatedWidget> with TickerProviderStateMixin{
  AnimationController _animationController;
  Animation<BorderRadius> _borderRadis;

  @override
  void initState(){
    super.initState();
    
    _animationController = AnimationController(duration: const Duration(seconds: 1),vsync: this)
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        _animationController.reverse();
      }else if(status == AnimationStatus.dismissed){
        _animationController.forward();
      }
    });

    _borderRadis = BorderRadiusTween(
      begin: BorderRadius.circular(100),
      end: BorderRadius.circular(0)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _borderRadis,
      builder: (context, child){
        return Center(
          child: Container(
            child: FlutterLogo(
              size: 200,
            ),
            alignment: Alignment.bottomCenter,
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: _borderRadis.value
            ),
          ),
        );
      },
    );
  }
}