import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

enum CortexEndPoints {
  Nothing,
  Connection,
  getCortexInfo,
  getUserLogin,
  requestAccess,
  hasAccessRight,
  disconnectControlDevice
}

class CortexHelper {
  late WebSocketChannel channel;
  var currentEndPoint = null;

  CortexHelper() {
    _ConnectToWSS();
  }

  void _ConnectToWSS() {
    currentEndPoint = CortexEndPoints.Connection;
    channel = WebSocketChannel.connect(
      Uri.parse('wss://localhost:6868'),
    );

    if (channel != null)
      print('Connected successfully 200!');
    else
      print('Connected Bad 400 !');
  }

  void CloseWss() {
    channel.sink.close();
  }

  void getCortexInfo() {
    currentEndPoint = CortexEndPoints.getCortexInfo;

    String data =
        jsonEncode({"id": 1, "jsonrpc": "2.0", "method": "getCortexInfo"});
    channel.sink.add(data);
  }

  void getUserLogin() {
    currentEndPoint = CortexEndPoints.getUserLogin;

    String data =
        jsonEncode({"id": 1, "jsonrpc": "2.0", "method": "getUserLogin"});
    channel.sink.add(data);
  }

  void disconnectControlDevice(var headsetID) {
    currentEndPoint = CortexEndPoints.disconnectControlDevice;

    String data = jsonEncode({
      "id": 1,
      "jsonrpc": "2.0",
      "method": "controlDevice",
      "params": {"command": "disconnect", "headset": headsetID}
    });

    channel.sink.add(data);
  }

  String userLoginResponse(var jsonResult) {
    Map<String, dynamic> map = jsonDecode(jsonResult);
    var resultArray = jsonDecode(jsonResult)['result'] as List;

    if (resultArray.length <= 0) return "noUser";

    if (resultArray[0]['currentOSUId'] == resultArray[0]['loggedInOSUId']) {
      return "loggedIN";
    } else {
      return "differentOS";
    }
  }

  String cortexInfoResponse(var jsonResult) {
    Map<String, dynamic> map = jsonDecode(jsonResult);

    String text = "non";
    if (!map.isEmpty)
      text =
          "buildDate : ${map['result']['buildDate']}\nbuildNumber : ${map['result']['buildNumber']}\nversion : ${map['result']['version']}";

    return text;
  }
}
