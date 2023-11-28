import 'dart:async';
import 'dart:math' as math;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip Bottle App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: FlipBottleApp(),
    );
  }
}

class FlipBottleApp extends StatefulWidget {
  @override
  _FlipBottleAppState createState() => _FlipBottleAppState();
}

class _FlipBottleAppState extends State<FlipBottleApp> with TickerProviderStateMixin {
  bool _isFlipping = false;
  int _flipCount = 0;
  late AnimationController controller;
  Duration duration = Duration(milliseconds: 150);

  // Add variable to store the current image asset path
  String _bottleImageAssetPath = 'assets/images2/bottle2.png';

  // Adjust the size of the second image
  double _bottleImageSize = 300.0;

  void _flipBottle() {
    if (!_isFlipping) {
      _isFlipping = true;
      _flipCount++;
      _flipHelper();
    }
  }

  void _flipHelper() async {
    while (_isFlipping) {
      await Future.delayed(duration, () {
        setState(() {
          if (_flipCount % 1 == 0) {
            // Land the bottle
            _isFlipping = false;
          } else {
            // Flip the bottle again
            _flipCount++;
            // Recreate the timer with the updated duration
            if (_isFlipping) {
              _flipHelper();
            }
          }
        });
      });
    }
  }

  void _changeDuration(int newDuration) {
    setState(() {
      duration = Duration(milliseconds: newDuration);
      // Dispose the existing controller and create a new one with the updated duration
      controller.dispose();
      controller = AnimationController(
        vsync: this,
        duration: duration,
      );
    });
  }

  // Add method to change the bottle image
  void _changeBottleImage(String newImageAssetPath) {
    setState(() {
      _bottleImageAssetPath = newImageAssetPath;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: duration,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flip Bottle'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Show the bottle
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return IgnorePointer(
                  ignoring: _isFlipping,
                  child: RotationTransition(
                    child: Image.asset(
                      _bottleImageAssetPath,
                      width: _bottleImageSize,
                      height: _bottleImageSize,
                    ),
                    turns: Tween<double>(begin: 0, end: 1).animate(controller),
                    alignment: Alignment.center,
                  ),
                );
              },
            ),
            // Show the flip count
            Text(
              '$_flipCount',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Buttons for changing flip duration with padding
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _changeDuration(400),
                    child: Text('400 ms'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeDuration(600),
                    child: Text('600 ms'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeDuration(800),
                    child: Text('800 ms'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeDuration(1000),
                    child: Text('1000 ms'),
                  ),
                ],
              ),
            ),
            // Buttons for changing bottle image with padding
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _changeBottleImage('assets/images2/bottle2.png'),
                    child: Text('Wine Bottle'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeBottleImage('assets/images2/juice_bottle.jpg'),
                    child: Text('Juice Bottle'),
                  ),
                    ElevatedButton(
                    onPressed: () => _changeBottleImage('assets/images2/cola_bottle.jpg'),
                    child: Text('Coca Cola Bottle'),
                  ),
                  ElevatedButton(
                    onPressed: () => _changeBottleImage('assets/images2/water_bottle1.jpg'),
                    child: Text('Water Bottle'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _flipBottle();
          controller.forward(from: 0.0);
        },
        tooltip: 'Flip Bottle',
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

