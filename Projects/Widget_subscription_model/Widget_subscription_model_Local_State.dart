/*
* In this example, the ChangeNotifierProvider is placed within the MyHomePage widget, making the Counter instance available only within MyHomePage and its descendants:
* Local State (Page or Widget-Specific State):
* When the state is only needed within a specific part of the widget tree (e.g., a specific page or section of the app), you can place the ChangeNotifierProvider within that part of the widget tree.
*/										  
		   
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is a reimplementation of the default Flutter application using provider + [ChangeNotifier].

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    const MyApp()
  );
}

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
      create: (context) => Counter(),
      child: Consumer<Counter>(// the entire widget is considered a consumer
          builder: (context, provider, child) =>
          Scaffold(
            appBar: AppBar(
              title: const Text('Example'),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('You have pushed the button this many times:'),
                  const Count(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              key: const Key('increment_floatingActionButton'),
              onPressed: () => Provider.of<Counter>(context, listen: false).increment(),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ),
        ),
    );
  }
}

class Count extends StatelessWidget {
  const Count({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      /// Calls `context.watch` to make [Count] rebuild when [Counter] changes.
      '${context.watch<Counter>().count}',
      key: const Key('counterState'),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}