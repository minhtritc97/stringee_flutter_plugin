import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stringee_flutter_plugin/stringee_flutter_plugin.dart';
import 'package:stringee_flutter_plugin_example/Chat.dart';

import 'Call.dart';

var user1 = 'PUT_YOUR_TOKEN_HERE';
var user2 = 'PUT_YOUR_TOKEN2_HERE';

StringeeClient client = StringeeClient();

String strUserId = "";

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: "OneToOneCallSample", home: new MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String myUserId = 'Not connected...';
  bool isAppInBackground = false;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();

    /// Lắng nghe sự kiện của StringeeClient(kết nối, cuộc gọi đến...)
    client.eventStreamController.stream.listen((event) {
      Map<dynamic, dynamic> map = event;
      switch (map['eventType']) {
        case StringeeClientEvents.didConnect:
          handleDidConnectEvent();
          break;
        case StringeeClientEvents.didDisconnect:
          handleDiddisconnectEvent();
          break;
        case StringeeClientEvents.didFailWithError:
          handleDidFailWithErrorEvent(
              map['body']['code'], map['body']['message']);
          break;
        case StringeeClientEvents.requestAccessToken:
          handleRequestAccessTokenEvent();
          break;
        case StringeeClientEvents.didReceiveCustomMessage:
          handleDidReceiveCustomMessageEvent(map['body']);
          break;
        case StringeeClientEvents.incomingCall:
          StringeeCall call = map['body'];
          handleIncomingCallEvent(call);
          break;
        case StringeeClientEvents.incomingCall2:
          StringeeCall2 call = map['body'];
          handleIncomingCall2Event(call);
          break;
        case StringeeClientEvents.didReceiveObjectChange:
          StringeeObjectChange objectChange = map['body'];
          print(objectChange.objectType.toString() +
              '\t' +
              objectChange.type.toString());
          print(objectChange.objects.toString());
          break;
        default:
          break;
      }
    });

    /// Connect
    client.connect(user2);
  }

  @override
  Widget build(BuildContext context) {
    Widget topText = new Container(
      padding: EdgeInsets.only(left: 10.0, top: 10.0),
      child: new Text(
        'Connected as: $myUserId',
        style: new TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("OneToOneCallSample"),
        backgroundColor: Colors.indigo[600],
      ),
      body: new Stack(
        children: <Widget>[topText, new MyForm()],
      ),
    );
  }

  //region Handle Client Event
  void handleDidConnectEvent() {
    setState(() {
      myUserId = client.userId;
    });
  }

  void handleDiddisconnectEvent() {
    setState(() {
      myUserId = 'Not connected';
    });
  }

  void handleDidFailWithErrorEvent(int code, String message) {
    print('code: ' + code.toString() + '\nmessage: ' + message);
  }

  void handleRequestAccessTokenEvent() {
    print('Request new access token');
  }

  void handleDidReceiveCustomMessageEvent(Map<dynamic, dynamic> map) {
    print('from: ' + map['fromUserId'] + '\nmessage: ' + map['message']);
  }

  void handleIncomingCallEvent(StringeeCall call) {
    showCallScreen(call, null);
  }

  void handleIncomingCall2Event(StringeeCall2 call) {
    showCallScreen(null, call);
  }

  void showCallScreen(StringeeCall call, StringeeCall2 call2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Call(
          fromUserId: call != null ? call.from : call2.from,
          toUserId: call != null ? call.to : call2.to,
          isVideoCall: call != null ? call.isVideoCall : call2.isVideoCall,
          callType: call != null
              ? StringeeObjectEventType.call
              : StringeeObjectEventType.call2,
          showIncomingUi: true,
          incomingCall2: call != null ? null : call2,
          incomingCall: call != null ? call : null,
        ),
      ),
    );
  }
//endregion
}

class MyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyFormState();
  }
}

class _MyFormState extends State<MyForm> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Form(
//      key: _formKey,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(20.0),
            child: new TextField(
              onChanged: (String value) {
                _changeText(value);
              },
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Container(
                          height: 40.0,
                          width: 175.0,
                          child: new RaisedButton(
                            color: Colors.grey[300],
                            textColor: Colors.black,
                            onPressed: () {
                              _CallTapped(false, StringeeObjectEventType.call);
                            },
                            child: Text('CALL'),
                          ),
                        ),
                        new Container(
                          height: 40.0,
                          width: 175.0,
                          margin: EdgeInsets.only(top: 20.0),
                          child: new RaisedButton(
                            color: Colors.grey[300],
                            textColor: Colors.black,
                            onPressed: () {
                              _CallTapped(true, StringeeObjectEventType.call);
                            },
                            child: Text('VIDEOCALL'),
                          ),
                        ),
                      ],
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Container(
                          height: 40.0,
                          width: 175.0,
                          child: new RaisedButton(
                            color: Colors.grey[300],
                            textColor: Colors.black,
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            onPressed: () {
                              _CallTapped(false, StringeeObjectEventType.call2);
                            },
                            child: Text('CALL2'),
                          ),
                        ),
                        new Container(
                          height: 40.0,
                          width: 175.0,
                          margin: EdgeInsets.only(top: 20.0),
                          child: new RaisedButton(
                            color: Colors.grey[300],
                            textColor: Colors.black,
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            onPressed: () {
                              _CallTapped(true, StringeeObjectEventType.call2);
                            },
                            child: Text('VIDEOCALL2'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                new Container(
                  height: 40.0,
                  width: 175.0,
                  margin: EdgeInsets.only(top: 20.0),
                  child: new RaisedButton(
                    color: Colors.grey[300],
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat(
                                    client: client,
                                  )));
                    },
                    child: Text('CHAT'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeText(String val) {
    setState(() {
      strUserId = val;
    });
  }

  void _CallTapped(bool isVideoCall, StringeeObjectEventType callType) {
    if (strUserId.isEmpty || !client.hasConnected) return;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Call(
              fromUserId: client.userId,
              toUserId: strUserId,
              isVideoCall: isVideoCall,
              callType: callType,
              showIncomingUi: false)),
    );
  }
}
