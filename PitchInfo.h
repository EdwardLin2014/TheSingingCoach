//
//  PitchInfo.h
//  FFTCepstrum
//
//  Created by Edward on 16/8/14.
//  Copyright (c) 2014 Edward. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PitchInfo : NSObject

@property Float32 _maxAmp;
@property int _bin;
@property Float32 _frequency;
@property Float32 _midiNum;
@property NSString* _pitch;
@property NSString* _pitchAboveNoise;

-(id)init;
-(void)resetParameters;

+ (Float32)freqToMIDI:(Float32)frequency;
+ (Float32)midiToFreq:(Float32)midiNote;

+ (NSString*)midiToPitch:(Float32)midiNote;
+ (Float32)pitchToMIDI:(NSString*)pitch;

+ (Float32)centDiffInPitch:(NSString*)pitchA with:(NSString*)pitchB;
+ (Float32)centDiffInFreq:(Float32)frequencyA with:(Float32)frequencyB;

@end
