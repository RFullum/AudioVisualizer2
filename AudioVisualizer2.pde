/*
*  Audio visualizer:
*  Analyzes audio from mic input via amplitude and FFT analysis.
*  Uses FFT band amplitude to control height (Y values) of wiggly reaching arm branches.
*  Uses full spectrum amplitude to control the left/right (X values) of wiggly reaching arm branches.
*  (See Branch.pde for more information of source and credits)
*  
*  Robert Fullum, August, 2020.
*/

import processing.sound.*;
  

// Audio Variables
Amplitude amp;
AudioIn audioIn;
FFT fft;
int fftResolution = 5;    // the power you're raising 2 to
int bands = (int)pow(2, fftResolution);                        
float smoothingFactor = 0.1f;          // Smooths FFT response for better visual representation
float[] sumBands = new float[bands];;  // Used in FFT smoothing


// Branch Variables
Branch[] branch = new Branch[bands];

int numBranchSegments = 15;
float branchSegmentLength = 50.0f;



void setup()
{
  fullScreen();
  
  // Audio Setup
  amp = new Amplitude(this);
  audioIn = new AudioIn(this, 0);
  audioIn.start();
  amp.input(audioIn);
  
  fft = new FFT(this, bands);
  fft.input(audioIn);
  
  // Branch setup
  for (int i=0; i<bands; i++)
  {
    branch[i] = new Branch(numBranchSegments, branchSegmentLength, bands, i);
    branch[i].branchSetup();
  }
  
  
}



void draw()
{
  background(0);
  
  // Audio Analyze
  float ampVal = amp.analyze();
  fft.analyze();
  
  // FFT smoothing
  for (int i=0; i<bands; i++)
  {
    sumBands[i] += (fft.spectrum[i] - sumBands[i]) * smoothingFactor;
  }
  
  // Send FFT and Amp values to Branch class instances and draws branches.
  for (int i=0; i<bands; i++)
  {
    branch[i].setAmplitude(sumBands[i]);
    branch[i].setAmplitudeIncrementer(ampVal);
    branch[i].branchDraw();
  }

}
