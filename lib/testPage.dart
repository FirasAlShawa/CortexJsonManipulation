import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class TestPage extends StatefulWidget{
    final channel;
  const TestPage({Key? key, required this.channel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TestPageState();
    
  }
  
  class TestPageState extends State<TestPage> {
    //check Connecton
    Map<String,dynamic> getCortexInfoRequest  ={
      "id":1,
      "jsonrpc":"2.0",
      "method":"getCortexInfo"
    };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
      home: Scaffold(
      appBar: AppBar(title: Text("Test Cortex",),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: (){
                widget.channel.listen((){
                widget.channel.snik.add(getCortexInfoRequest);
                });
              },
            ),
          ),
          StreamBuilder(
            stream: widget.channel.stream,
            builder: (context, AsyncSnapshot snapshot){
              print(snapshot.data);
              return Padding(
                padding: const EdgeInsets.only(top:20),
                child: Text(snapshot.hasData?'${snapshot.data.toString()}':'No response!!'),
                );
            },
            ),
        ],
      ),
      ),
    );
  }
}

