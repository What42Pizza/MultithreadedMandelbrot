void LaunchThreads (String Method) {
  FinishedThreads = 0;
  CurrentThreadID = 0;
  int ActualNumOfThreads = NumOfThreads;
  if (Interlacing) NumOfThreads *= InterlacingAmount;
  for (int i = 0; i < ActualNumOfThreads; i ++) {
    thread (Method);
    //Threaded_DrawMandelbrot();
  }
  while (FinishedThreads < ActualNumOfThreads) DoBusyWork();
  if (Interlacing) NumOfThreads /= InterlacingAmount;
}





int CurrentThreadID = 0;

volatile int FinishedThreads = 0;



synchronized int GetThreadID() {
  if (Interlacing) {
    CurrentThreadID += InterlacingAmount;
    return CurrentThreadID - 1 + frameCount % InterlacingAmount;
  } else {
    CurrentThreadID ++;
    return CurrentThreadID - 1;
  }
}



synchronized void IncFinishedThreads() {
  FinishedThreads ++;
}



void DoBusyWork() {
  long EndNano = System.nanoTime() + 1000;
  while (System.nanoTime() < EndNano) {
    byte Void = -128;
    while (Void < 127) Void ++;
  }
}
