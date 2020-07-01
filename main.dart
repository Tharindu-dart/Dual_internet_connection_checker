import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Mobile data detected & internet connection confirmed.
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Wifi detected & internet connection confirmed.
        return true;
      } else {
        // Wifi detected but no internet connection found.
        return false;
      }
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: isInternet(),
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot);

            //here you can use == with waiting,   != with done
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return Center(
                child: Text('${snapshot.data}'),
              );
            }
          },
        ),
      ),
    );
  }
}
