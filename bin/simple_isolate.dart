
import 'dart:io';
import 'dart:isolate';

void main() async{

  /*
  Create new Isolate, just after creating new Isolate control of this main Isolate,
  start executing next instructions below the new Isolate creation line,
  where as new Isolate keep working in parallel of main/other Isolates
   */
  print('Going to create new Isolate');
  Isolate isolate=await Isolate.spawn(runSomethingOnNewIsolate, 'first long task');
  print('New Isolate Created and it started his work');

  for(int progress=0;progress<500;progress++){
    print('Main Isolate progress : $progress');
  }

  /*
  After executing all the instructions of main method app will killed,
  so to pause the main method(using stdin.first), so that we can wait in case
  "new Isolate" not finish yet.

  Press Enter to move forward
   */
  await stdin.first;

  //Kill new Isolate
  isolate.kill(priority: Isolate.immediate);
  isolate=null;
  print('new Isolate killed');

}

void runSomethingOnNewIsolate(String arg) {

  print('New Isolate Created With arg : $arg');

  //Do long running task here
  for(int progress=0; progress<500 ;progress++){

    print('new Isolate progress : $progress');

  }
  print('task completed');
  //End long running task
}