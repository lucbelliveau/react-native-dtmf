//
//  ToneGenerator.m
//  BigDataVoice
//
//  Created by Luc Belliveau on 2017-05-06.
//  Copyright © 2017 Luc Belliveau. All rights reserved.
//

#import "ToneGenerator.h"

static AudioUnit toneUnit;
static double sampleRate = 8000.0;
static int freq1 = 1;
static int freq2 = 1;

static double sineMultiplierPerSample, sineMultiplierPerSample_2nd;
static double samplesPerSine, samplesPerSine_2nd;
static double samplePosInSine, samplePosInSine_2nd;
const float M_2PI = 3.14159265358979323846f * 2;

//void startTone(int dtmf) {
void startTone(int dtmf, int durationMs) {
  // Create the audio unit as shown above
  initialize();
  
  switch(dtmf)
  {
    case DTMF_1: case DTMF_2: case DTMF_3: case DTMF_A: freq1 =  697; break;
    case DTMF_4: case DTMF_5: case DTMF_6: case DTMF_B: freq1 =  770; break;
    case DTMF_7: case DTMF_8: case DTMF_9: case DTMF_C: freq1 =  852; break;
    case DTMF_S: case DTMF_0: case DTMF_P: case DTMF_D: freq1 =  941; break;
  }
  switch(dtmf)
  {
    case DTMF_1: case DTMF_4: case DTMF_7: case DTMF_S: freq2 =  1209; break;
    case DTMF_2: case DTMF_5: case DTMF_8: case DTMF_0: freq2 =  1336; break;
    case DTMF_3: case DTMF_6: case DTMF_9: case DTMF_P: freq2 =  1477; break;
    case DTMF_A: case DTMF_B: case DTMF_C: case DTMF_D: freq2 =  1633; break;
  }
  
  samplesPerSine = sampleRate / freq1;
  sineMultiplierPerSample = M_2PI / samplesPerSine;
  samplesPerSine_2nd = sampleRate / freq2;
  sineMultiplierPerSample_2nd = M_2PI / samplesPerSine_2nd;
  while (samplePosInSine >= samplesPerSine) samplePosInSine -= samplesPerSine;
  while (samplePosInSine_2nd >= samplesPerSine_2nd) samplePosInSine_2nd -= samplesPerSine_2nd;
  
  // Finalize parameters on the unit
  OSErr err = AudioUnitInitialize(toneUnit);
  
  // Start playback
  err = AudioOutputUnitStart(toneUnit);
    
  // Stop the tone after durationMs (or until stopTone is called)
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((durationMs/1000) * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    stopTone();
  });
}

void stopTone() {
  // Tear it down in reverse
  AudioOutputUnitStop(toneUnit);
  AudioUnitUninitialize(toneUnit);
  AudioComponentInstanceDispose(toneUnit);
  toneUnit = nil;
}

void initialize() {
  
  // Configure the search parameters to find the default playback output unit
  // (called the kAudioUnitSubType_RemoteIO on iOS but
  // kAudioUnitSubType_DefaultOutput on Mac OS X)
  AudioComponentDescription defaultOutputDescription;
  defaultOutputDescription.componentType = kAudioUnitType_Output;
  defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
  defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
  defaultOutputDescription.componentFlags = 0;
  defaultOutputDescription.componentFlagsMask = 0;
  
  // Get the default playback output unit
  AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
  
  // Create a new unit based on this that we'll use for output
  OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
  
  // Set our tone rendering function on the unit
  AURenderCallbackStruct input;
  input.inputProc = RenderTone;
  err = AudioUnitSetProperty(toneUnit,
                             kAudioUnitProperty_SetRenderCallback,
                             kAudioUnitScope_Input,
                             0,
                             &input,
                             sizeof(input));
  
  // Set the format to 32 bit, single channel, floating point, linear PCM
  const int four_bytes_per_float = 4;
  const int eight_bits_per_byte = 8;
  AudioStreamBasicDescription streamFormat;
  streamFormat.mSampleRate = sampleRate;
  streamFormat.mFormatID = kAudioFormatLinearPCM;
  streamFormat.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
  streamFormat.mBytesPerPacket = four_bytes_per_float;
  streamFormat.mFramesPerPacket = 1;
  streamFormat.mBytesPerFrame = four_bytes_per_float;
  streamFormat.mChannelsPerFrame = 1;
  streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
  err = AudioUnitSetProperty (toneUnit,
                              kAudioUnitProperty_StreamFormat,
                              kAudioUnitScope_Input,
                              0,
                              &streamFormat,
                              sizeof(AudioStreamBasicDescription));
}

OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags *ioActionFlags,
                    const AudioTimeStamp *inTimeStamp,
                    UInt32 inBusNumber,
                    UInt32 inNumberFrames,
                    AudioBufferList *ioData)

{
  // Fixed amplitude is good enough for our purposes
  const double amplitude = 0.25;
  
  // This is a mono tone generator so we only need the first buffer
  const int channel = 0;
  Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
  
  // Generate the samples
  Float32 sample;
  for (UInt32 frame = 0; frame < inNumberFrames; frame++)
  {
    sample = (sin(sineMultiplierPerSample * samplePosInSine) +
              sin(sineMultiplierPerSample_2nd * samplePosInSine_2nd)) * amplitude;
    samplePosInSine_2nd++;
    while (samplePosInSine_2nd >= samplesPerSine_2nd) samplePosInSine_2nd -= samplesPerSine_2nd;
    samplePosInSine++;
    while (samplePosInSine >= samplesPerSine) samplePosInSine -= samplesPerSine;
    
    buffer[frame] = sample;
  }
  return noErr;
}
