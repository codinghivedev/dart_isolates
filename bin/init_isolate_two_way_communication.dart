import 'dart:async';
import 'dart:io';
import 'dart:isolate';

void main() async{
  SendPort mainToIsolateStream = await initIsolate(messageCallBack: (i) {
    print('download progress : $i');
  });
  mainToIsolateStream.send('This is from main()');
}


Future<SendPort> initIsolate({messageCallBack}) async {
  void Function(dynamic) responseCallBack=messageCallBack;

  Completer completer = Completer<SendPort>();
  ReceivePort isolateToMainStream = ReceivePort();

  isolateToMainStream.listen((data) {
    if (data is SendPort) {
      SendPort mainToIsolateStream = data;
      completer.complete(mainToIsolateStream);
    } else {
      print('[isolateToMainStream] $data');
      responseCallBack(data);
    }
  });

  Isolate myIsolateInstance = await Isolate.spawn(myIsolate, isolateToMainStream.sendPort);
  return completer.future;
}

void myIsolate(SendPort isolateToMainStream) {
  ReceivePort mainToIsolateStream = ReceivePort();
  isolateToMainStream.send(mainToIsolateStream.sendPort);

  mainToIsolateStream.listen((data) {
    print('[mainToIsolateStream] $data');
    exit(0);
  });

  isolateToMainStream.send('This is from myIsolate()');
}