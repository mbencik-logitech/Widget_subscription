import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*  What is the Provider Package?
 *  The Provider package is a state management solution for Flutter applications. It allows you to 
 *  manage and share state in a clean and efficient manner. At its core, Provider leverages the 
 *  ChangeNotifier class, making it easy to notify listeners when state changes occur.
 *  https://medium.com/@accnd163/understanding-flutters-provider-package-for-state-management-a-practical-guide-with-a-sample-e5134321b685
 *  https://www.youtube.com/watch?v=FUDhozpnTUw
 *  https://www.youtube.com/watch?v=uQuxrZE2dqA
 *  https://www.youtube.com/watch?v=t_i5_QHalvk&list=PLgGlvOHs_ZdABf3vwR4GeJZbAyfQzTr9O&index=2&t=61s
 * */

class MyModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyRouteAware extends RouteAware {
  final BuildContext context;

  MyRouteAware(this.context);

}


class MyChangeNotifierWidget extends StatelessWidget {
  final MyRouteAware routeAware;

  MyChangeNotifierWidget({Key? key, required this.routeAware}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MyModel>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Count: ${model.count}'),
            ElevatedButton(
              onPressed: 
              () {
                model.increment();
              },
              child: Text('Increment'),
            ),
            OutlinedButton(
              onPressed: 
                () {
                model.increment(); 
                Navigator.of(context).push(
                  MaterialPageRoute( builder: (context) => NextPage(), ),
                ); 
              },
              child: Text('Go to next page'),
            ),
          ],
        ),
      ),
    );
  }
}


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          final routeAware = MyRouteAware(context);
          return MyChangeNotifierWidget(routeAware: routeAware);
        },
      ),
      navigatorObservers: [routeObserver],
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Go back'),
        ),
      ),
    );
  }
}

