//
//  ToneGenerator.h
//  BigDataVoice
//
//  Created by Luc Belliveau on 2017-05-06.
//  Copyright © 2017 Luc Belliveau. All rights reserved.
//

#import <MacTypes.h>
#import <AudioUnit/AudioUnit.h>

#ifndef ToneGenerator_h
#define ToneGenerator_h

OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags *ioActionFlags,
                    const AudioTimeStamp *inTimeStamp,
                    UInt32 inBusNumber,
                    UInt32 inNumberFrames,
                    AudioBufferList *ioData);

void initialize();
//void startTone(int dtmf);
void startTone(int dtmf, int duration);
void stopTone();

typedef enum {
  DTMF_1, DTMF_2, DTMF_3, DTMF_4, DTMF_5, DTMF_6, DTMF_7, DTMF_8, DTMF_9, DTMF_0,
  DTMF_A, DTMF_B, DTMF_C, DTMF_D, DTMF_S, DTMF_P
} DTMF_TONES;

#endif /* ToneGenerator_h */
