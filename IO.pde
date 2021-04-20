void mouseWheel(MouseEvent Event) {
  // to get the camera to zoom into the mouse: find where the mouse is pointing, change the zoom, find where the mouse is pointer now, and move the camera so that it's pointing in the same pos as before the zoom
  float ScrollAmount = Event.getCount();
  float StartMapX = CameraX + mouseX / Zoom;
  float StartMapY = CameraY + mouseY / Zoom;
  Zoom *= pow (2, -ScrollAmount / 10);
  float NewMapX = CameraX + mouseX / Zoom;
  float NewMapY = CameraY + mouseY / Zoom;
  CameraX -= (NewMapX - StartMapX);
  CameraY -= (NewMapY - StartMapY);
}



void keyPressed() {
  switch (key) {
    
    case ('e'):
      NumOfIterations *= 1.5;
      break;
    
    case ('q'):
      NumOfIterations /= 1.5;
      break;
    
    case ('r'):
      Reset();
      break;
    
    case (' '):
      MethodNum = (MethodNum == 0) ? UsedOptimizedVersion + 1 : 0;
      break;
    
    case ('o'):
      UsedOptimizedVersion ++;
      UsedOptimizedVersion %= MethodNames.length - 1;
      if (MethodNum != 0) MethodNum = UsedOptimizedVersion + 1;
      break;
    
    case ('i'):
      Interlacing = !Interlacing;
      break;
    
    case ('u'):
      InterlacingAmount ++;
      break;
    
    case ('j'):
      InterlacingAmount --;
      break;
    
  }
}
