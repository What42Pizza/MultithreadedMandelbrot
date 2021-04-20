// Created 04/17/21
// Last updated 04/19/21



// Settings

int NumOfThreads = 10;
int NumOfIterations = 100;

final color[] Colors = {
  color (255,   0, 0  ),
  color (255, 255, 0  ),
  color (  0, 255, 0  ),
  color (  0, 255, 255),
  color (  0,   0, 255),
  color (255,   0, 255),
};

final int Optimization_SkipAmount = 10;





// Imports
//import java.math.BigDecimal;





// Vars

int MethodNum = 0;
int UsedOptimizedVersion = 0;
boolean Interlacing = false;
int InterlacingAmount = 2;

int StartNumOfIterations = NumOfIterations;

float CameraX = 0;
float CameraY = 0;
float Zoom = 200;

final String[] MethodNames = {
  "Threaded_DrawMandelbrot",
  "Threaded_DrawMandelbrot_Optimized2",
  "Threaded_DrawMandelbrot_Optimized1",
};





void setup() {
  //fullScreen();
  size (512, 512);
  Reset();
  frameRate (10);
}



IntList Millises = new IntList();
int TotalMillis = 0;

void draw() {
  int StartMillis = millis();
  
  pixels = new color [width * height];
  LaunchThreads (MethodNames[MethodNum]);
  g.pixels = pixels;
  updatePixels();
  
  int MillisTime = millis() - StartMillis;
  Millises.append(MillisTime);
  TotalMillis += MillisTime;
  if (Millises.size() > 10) TotalMillis -= Millises.remove(0);
  
  fill (0);
  text (MillisTime + "   " + (TotalMillis / 10) + "   " + frameRate, 5, 15);
  if (MethodNum != 0) text ("OPTIMIZED", 5, 30);
  
}





void Reset() {
  Zoom = height / 4.0;
  CameraX = (width  / -2) / Zoom;
  CameraY = (height / -2) / Zoom;
  NumOfIterations = StartNumOfIterations;
  MethodNum = 0;
  Interlacing = false;
  InterlacingAmount = 2;
}










void Threaded_DrawMandelbrot() {
  int ThreadID = GetThreadID();
  for (int y = ThreadID; y < height; y += NumOfThreads) {
    for (int x = 0; x < width; x ++) {
      pixels[x + y * width] = GetColorOfPixel (x, y);
    }
  }
  IncFinishedThreads();
}



void Threaded_DrawMandelbrot_Optimized1() {
  int ThreadID = GetThreadID();
  for (int y = ThreadID; y < height; y += NumOfThreads) {
    int Index = y * width;
    for (int x = 0; x < width; x ++) {
      int ThisColor = GetColorOfPixel (x, y);
      pixels[Index] = ThisColor;
      Index ++;
      if (x + Optimization_SkipAmount < width) {
        int SkippedColor = GetColorOfPixel (x + Optimization_SkipAmount, y);
        if (SkippedColor == ThisColor) {
          int EndX = x + Optimization_SkipAmount;
          for (int _ = 0; x < EndX; x ++) {
            pixels[Index] = ThisColor;
            Index ++;
          }
          x --;
          Index --;
        }
      }
    }
  }
  IncFinishedThreads();
}



void Threaded_DrawMandelbrot_Optimized2() {
  int ThreadID = GetThreadID();
  for (int y = ThreadID; y < height; y += NumOfThreads) {
    int Index = y * width;
    for (int x = 0; x < width; x ++) {
      int ThisColor = GetColorOfPixel (x, y);
      int EndX = x + Optimization_SkipAmount;
      for (int _ = 0; x < EndX; x ++) {
        pixels[Index] = ThisColor;
        Index ++;
      }
    }
  }
  IncFinishedThreads();
}





color GetColorOfPixel (int ScreenX, int ScreenY) {
  float MapX = CameraX + ScreenX / Zoom;
  float MapY = CameraY + ScreenY / Zoom;
  return GetColorOfPoint (MapX, MapY);
}





color GetColorOfPoint (float XPos, float YPos) {
  
  /*
  // WAAAAAAY TOO SLOW (but probably accurate)
  BigDecimal CX = new BigDecimal (XPos);
  BigDecimal CY = new BigDecimal (YPos);
  BigDecimal ZX = CX.add (new BigDecimal (0)); // this is just the easiest way to clone
  BigDecimal ZY = CY.add (new BigDecimal (0));
  
  int i = 0;
  int StartMillis = millis();
  while (i < NumOfIterations) {
    BigDecimal ZXSquared = ZX.multiply(ZX);
    BigDecimal ZYSquared = ZY.multiply(ZY);
    BigDecimal Temp = ZX.add(new BigDecimal(0));
    ZX = (ZXSquared.subtract(ZYSquared).add(CX)).stripTrailingZeros();
    ZY = (Temp.multiply(ZY).multiply(new BigDecimal(2)).add(CY)).stripTrailingZeros();
    //if (i == 0) println (ZX.toString() + " " + ZY.toString());
    i ++;
    if (ZXSquared.intValue() + ZYSquared.intValue() >= 4) break;
  }
  println (millis() - StartMillis);
  //*/
  
  double ZX = XPos;
  double ZY = YPos;
  
  int i = 0;
  while (i < NumOfIterations) {
    double ZXSquared = ZX*ZX;
    double ZYSquared = ZY*ZY;
    double Temp = ZX;
    ZX = ZXSquared - ZYSquared + XPos;
    ZY = 2 * Temp * ZY + YPos;
    i ++;
    if (ZXSquared + ZYSquared >= 4) break;
  }
  
  return (i == NumOfIterations) ? color (0) : Colors[i%Colors.length];
}
