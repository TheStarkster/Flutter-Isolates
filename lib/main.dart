import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
  Future<void> computeFuture = Future.value();

  addButton1() {
    return FutureBuilder<void>(
      future: computeFuture,
      builder: (context, snapshot) {
        return OutlineButton(
          child: const Text('Main Isolate'),
          onPressed: createMainIsolateCallback(context, snapshot),
        );
      },
    );
  }

  addButton2() {
    return FutureBuilder<void>(
      future: computeFuture,
      builder: (context, snapshot) {
        return OutlineButton(
          child: const Text('Secondary Isolate'),
          onPressed: createSecondaryIsolateCallback(context, snapshot),
        );
      },
    );
  }

  VoidCallback createMainIsolateCallback(
      BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return () {
        setState(() {
          computeFuture = createOnMainIsolate().then((val) {
            showSnackBar(context, 'Main Isolate Value $val');
          });
        });
      };
    } else {
      return null;
    }
  }

  VoidCallback createSecondaryIsolateCallback(
      BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return () {
        setState(() {
          computeFuture = createOnSecondaryIsolate().then((val) {
            showSnackBar(context, 'Secondary Isolate Value $val');
          });
        });
      };
    } else {
      return null;
    }
  }

  Future<int> createOnMainIsolate() async {
    return await Future.delayed(Duration(milliseconds: 100), () => fib(40));
  }

  Future<int> createOnSecondaryIsolate() async {
    return await compute(fib, 40);
  }

  static int fib(int n) {
    int numb1 = n - 1;
    int numb2 = n - 2;
    if (1 == n) {
      return 0;
    } else if (0 == n) {
      return 1;
    } else {
      return (fib(numb1) + fib(numb2));
    }
  }

  showSnackBar(context, message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

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
            AnimatedWidget(),
            addButton1(),
            addButton2()
          ],
        ),
      ),
    );
  }
}

class AnimatedWidget extends StatefulWidget {
  @override
  AnimatedWidgetState createState() => AnimatedWidgetState();
}

class AnimatedWidgetState extends State<AnimatedWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<BorderRadius> _borderRadis;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });

    _borderRadis = BorderRadiusTween(
            begin: BorderRadius.circular(100), end: BorderRadius.circular(0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _borderRadis,
      builder: (context, child) {
        return Center(
          child: Container(
            child: FlutterLogo(
              size: 200,
            ),
            alignment: Alignment.bottomCenter,
            width: 350,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: _borderRadis.value),
          ),
        );
      },
    );
  }
}
