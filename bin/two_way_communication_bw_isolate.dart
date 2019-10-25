
import 'dart:isolate';

void main() async{

  ReceivePort receivePort= ReceivePort();

  /*
  Create new Isolate, just after creating new Isolate control of this main Isolate,
  start executing next instructions below the new Isolate creation line,
  where as new Isolate keep working in parallel of main/other Isolates
   */
  print('Going to create new Isolate');
  Isolate isolate=await Isolate.spawn(runSomethingOnNewIsolate, receivePort.sendPort);
  print('New Isolate Created and it started his work');


  for(int progress=0;progress<500;progress++){
    print('Main Isolate progress : $progress');
  }

  //To receive messages from new Isolate
  receivePort.listen((dynamic receivedData) {

    if (receivedData is SendPort) {
      SendPort sendPortOfNewIsolate = receivedData;
      for(int commond=0;commond<500;commond++){
        print('old Isolate commond : $commond');
        sendPortOfNewIsolate.send(commond);
      }
      //kill the new isolate no longer is needed
      isolate.kill(priority: Isolate.immediate);
      isolate=null;

    }else{
      print('Data from new isolate, commomd : $receivedData');

    }
  });

}

void runSomethingOnNewIsolate(SendPort sendPortOfOldIsolate) {

  ReceivePort receivePort=ReceivePort();

  print('New Isolate Created With arg data : ${sendPortOfOldIsolate}');
  //listen to messages send by old isolate
  receivePort.listen((dynamic receivedData) {
    print('new Isolate progress commond : $receivedData');
    sendPortOfOldIsolate.send(receivedData);
  });

  //sendPort send to old isolate, so it can send message to this isolate
  sendPortOfOldIsolate.send(receivePort.sendPort);
}