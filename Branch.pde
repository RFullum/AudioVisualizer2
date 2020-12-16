//
// https://processing.org/examples/reach2.html
// Based on Processing Example Reach 2
// Reach 2 based on code from Keith Peters.
//

class Branch
{
  // Branch variables
  int numSegments;
  float[] x;
  float[] y;
  float[] angle;
  float segmentLength;
  float targetX, targetY;
  
  // FFT variables
  float amplitude;
  int bands, instanceNum;
  
  // Animation Variables
  float counter = 0.0f;
  float amplitudeIncrementer = 0.0f;
  float incrementerThreshold = 0.5f;
  float incrementerScale = 0.5f;
  float xPointMult = 1.0;
  boolean multDirection = true;
  
  // Default constructor
  Branch()
  {
    numSegments = 10;
    x = new float[numSegments];
    y = new float[numSegments];
    angle = new float[numSegments];
    segmentLength = 26.0f;
    bands = 1;
    instanceNum = 1;
  }
  
  // Constructor with Arguments
  Branch(int segments, float segLength, int fftBands, int i)
  {
    numSegments = segments;
    x = new float[numSegments];
    y = new float[numSegments];
    angle = new float[numSegments];
    segmentLength = segLength;
    bands = fftBands;
    instanceNum = i;
  }
  
  // Sets up branch
  void branchSetup()
  {
    int divisionSize = width / bands;
    int divisionLocation = (divisionSize * (instanceNum + 1)) - (divisionSize / 2);
    
    x[x.length - 1] = divisionLocation;  // Base X coordinate, spaced evenly across width
    y[y.length - 1] = height;     // Base Y coordinate
  }
  
  // Draws branches
  void branchDraw()
  {
    // Reaches segment to the FFT band amplitude and Amp amplitude.
    // Amp value controls the increment of the counter, that oscillates as a function of Sine
    reachSegment( 0, (x[x.length - 1]) + sin(counter) * xPointMult, height - ( amplitude * height * ((float)instanceNum + 1.0f) ) );
    
    // only increment if the Amp is above threshold. Creates pulsing with music. Amplitude is scaled.
    if (amplitudeIncrementer > incrementerThreshold)
    {
      counter += amplitudeIncrementer * incrementerScale;
    }
    
    // Makes X value miltiplier increase and decrease width of branch X direction
    if (multDirection)
    {
      xPointMult += amplitude * ((float)instanceNum + 1.0f);
    }
    else
    {
      //xPointMult--;
      xPointMult -= amplitude * ((float)instanceNum + 1.0f);
    }
    
    // flips the direction of the X value mult between increase and decrease
    if (xPointMult > width || xPointMult < 0)
    {
      multDirection = !multDirection;
    }
    
    // Drawing segments accordingly
    for (int i=1; i<numSegments; i++)
    {
      reachSegment(i, targetX, targetY);
    }
    
    for (int i=x.length-1; i>=1; i--)
    {
      positionSegment(i, i-1);
    }
    
    for (int i=0; i<x.length; i++)
    {
      segment(x[i], y[i], angle[i], (i+2)*2, i);
    }
  }
  
  // Makes segment reach
  void reachSegment(int i, float xIn, float yIn)
  {
    float deltaX = xIn - x[i];
    float deltaY = yIn - y[i];
    angle[i] = atan2(deltaY, deltaX);
    targetX = xIn - cos(angle[i]) * segmentLength;
    targetY = yIn - sin(angle[i]) * segmentLength;
  }
  
  // Positions segments
  void positionSegment(int a, int b)
  {
    x[b] = x[a] + cos(angle[a]) * segmentLength;
    y[b] = y[a] + sin(angle[a]) * segmentLength;
  }
  
  // Create branch segments
  void segment(float x, float y, float a, float sw, int inc)
  {
    int redVal = (int)map((float)inc, 0.0f, (float)numSegments, 255.0f, 0.0f);
    int greenVal = (int)map((float)instanceNum, 0.0f, (float)bands, 0.0f, 255.0f);
    int blueVal = (int)map(xPointMult, 0.0f, 100.0f, 0.0f, 255.0f);
    int alphaAmt = (int)map(amplitude, 0.0f, 1.0f, 50.0f, 255.0f);
    
    stroke(redVal, greenVal, blueVal, alphaAmt);
    strokeWeight(sw);
    pushMatrix();
    translate(x, y);
    rotate(a);
    line(0, 0, segmentLength, 0);
    popMatrix();
  }
  
  // Gets amplitude from FFT band
  void setAmplitude(float amp)
  {
    amplitude = amp; // * (instanceNum + 1)
  }
  
  // Uses full spectrum amplitude to adjust the increment of the x axis motion
  void setAmplitudeIncrementer(float amp)
  {
    amplitudeIncrementer = amp;
  }


} 
