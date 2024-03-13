import 'package:flutter/material.dart';

class Kappa {
  Kappa(
    this.b,
    this.c,
    this.itemBuilder, {
    required this.builder,
    required this.children,
    required this.z,
  });

  Kappa.lol(
    this.c,
    this.itemBuilder, {
    required this.builder,
    required this.children,
    required this.z,
    this.b,
  });

  Kappa.lol2(
      this.b, this.builder, this.c, this.children, this.itemBuilder, this.z);

  Kappa.lol3({
    required this.builder,
    required this.c,
    required this.children,
    required this.itemBuilder,
    this.b,
    this.z,
  });

  Kappa.nani(
    this.builder,
    this.c,
    this.children,
    this.itemBuilder, [
    this.b,
    this.z,
  ]);

  final int? b;
  final int c;
  final int? z;
  final Widget Function() itemBuilder;
  final Widget children;
  final Widget Function() builder;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
      theme: ThemeData(primarySwatch: Colors.blue),
      title: 'Flutter Demo',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void asdsad(
  int b,
  int c,
  void Function(int a, int b) itemBuilder, {
  required Widget children,
  Widget Function({int? d, int? b})? builder,
  int? z,
}) {}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter({
    required int a,
    required int b,
  }) {
    setState(() {
      _counter++;
    });
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter(
            a: 1,
            b: 2,
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
