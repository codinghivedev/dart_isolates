
import 'dart:isolate';
import 'package:stream_channel/isolate_channel.dart';

//Bidirectional communication with isolates in Dart 2
void main() async {

  ReceivePort rPort =  ReceivePort();
  IsolateChannel channel = IsolateChannel.connectReceive(rPort);

  channel.stream.listen((data) {
    print('rootIsolate received : $data');
    channel.sink.add('How are you');
  });

  await Isolate.spawn(elIsolate, rPort.sendPort);

}

void elIsolate(SendPort sPort) {
  print("new isolate created");

  IsolateChannel channel = IsolateChannel.connectSend(sPort);
  channel.stream.listen((data) {
    print('newIsolate received : $data');
  });
  channel.sink.add("hi");
}