import 'dart:io';

import 'package:flutter/material.dart';

import 'CortexHelper.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // add your localhost detection logic here if you want
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cortex = CortexHelper();
  var connectionFlag = false;
  var currentEndPoint = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: cortex.getCortexInfo,
              child: Text("Get Cortex Info"),
            ),
            ElevatedButton(
              onPressed: cortex.getUserLogin,
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: () {
                cortex.disconnectControlDevice("gkkdfg2342");
              },
              child: Text("disconnectControlDevice"),
            ),
            const SizedBox(height: 24),

            //TODO : Print/Show the results from the WebSocket server
            StreamBuilder(
              stream: cortex.channel.stream,
              builder: (context, snapshot) {
                String message = "";

                switch (cortex.currentEndPoint) {
                  case CortexEndPoints.getCortexInfo:
                    message = cortex.cortexInfoResponse(snapshot.data);
                    break;
                  case CortexEndPoints.getUserLogin:
                    message = cortex.userLoginResponse(snapshot.data);
                    break;

                  default:
                    message = "non";
                }

                return Text(message);
              },
            )
            //TODO END
          ],
        ),
      ),
    );
  }
}
