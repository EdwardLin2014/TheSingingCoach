//
//  PitchInfo.m
//  FFTCepstrum
//
//  Created by Edward on 16/8/14.
//  Copyright (c) 2014 Edward. All rights reserved.
//

#import "PitchInfo.h"

@implementation PitchInfo

@synthesize _maxAmp;
@synthesize _bin;
@synthesize _frequency;
@synthesize _midiNum;
@synthesize _pitch;
@synthesize _pitchAboveNoise;

-(id)init
{
    if ([super init])
        [self resetParameters];
    
    return self;
}

-(void)resetParameters
{
    _maxAmp = -INFINITY;
    _bin = 0;
    _frequency = 0;
    _midiNum = 0;
    _pitch = @"nil";
    _pitchAboveNoise = @"nil";
}

+ (Float32)freqToMIDI:(Float32)frequency
{
    if (frequency <=0)
        return -1;
    else
        return 12*log2f(frequency/440) + 69;
}
+ (Float32)midiToFreq:(Float32)midiNote
{
    if (midiNote <=20)
        return -1;
    else
        return powf(2, (midiNote-69)/12)*440;
}
+ (NSString*)midiToPitch:(Float32)midiNote
{
    if (midiNote<=-1)
        return @"nil";
    
    int midi = (int)round((double)midiNote);
    NSArray *noteStrings = [[NSArray alloc] initWithObjects:@"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", nil];
    NSString *retval = [noteStrings objectAtIndex:midi%12];
    
    if(midi <= 23)
        retval = [retval stringByAppendingString:@"0"];
    else if(midi <= 35)
        retval = [retval stringByAppendingString:@"1"];
    else if(midi <= 47)
        retval = [retval stringByAppendingString:@"2"];
    else if(midi <= 59)
        retval = [retval stringByAppendingString:@"3"];
    else if(midi <= 71)
        retval = [retval stringByAppendingString:@"4"];
    else if(midi <= 83)
        retval = [retval stringByAppendingString:@"5"];
    else if(midi <= 95)
        retval = [retval stringByAppendingString:@"6"];
    else if(midi <= 107)
        retval = [retval stringByAppendingString:@"7"];
    else
        retval = [retval stringByAppendingString:@"8"];
    
    return retval;
}
+ (Float32)pitchToMIDI:(NSString*)pitch
{
    Float32 retval = -1;
    
    NSString* octave = [pitch substringFromIndex:([pitch length]-1)];
    NSString* note;
    if ([pitch length] == 3)
        note = [pitch substringToIndex:2];
    else if ([pitch length] == 2)
        note = [pitch substringToIndex:1];
    
    if ([octave isEqualToString:@"0"])
        retval = 12;
    else if ([octave isEqualToString:@"1"])
        retval = 24;
    else if ([octave isEqualToString:@"2"])
        retval = 36;
    else if ([octave isEqualToString:@"3"])
        retval = 48;
    else if ([octave isEqualToString:@"4"])
        retval = 60;
    else if ([octave isEqualToString:@"5"])
        retval = 72;
    else if ([octave isEqualToString:@"6"])
        retval = 84;
    else if ([octave isEqualToString:@"7"])
        retval = 96;
    else if ([octave isEqualToString:@"8"])
        retval = 108;
    
    if ([note isEqualToString:@"C"])
    {
        //Do nothing
    }
    else if ([note isEqualToString:@"C#"])
        retval += 1;
    else if ([note isEqualToString:@"D"])
        retval += 2;
    else if ([note isEqualToString:@"D#"])
        retval += 3;
    else if ([note isEqualToString:@"E"])
        retval += 4;
    else if ([note isEqualToString:@"F"])
        retval += 5;
    else if ([note isEqualToString:@"F#"])
        retval += 6;
    else if ([note isEqualToString:@"G"])
        retval += 7;
    else if ([note isEqualToString:@"G#"])
        retval += 8;
    else if ([note isEqualToString:@"A"])
        retval += 9;
    else if ([note isEqualToString:@"A#"])
        retval += 10;
    else if ([note isEqualToString:@"B"])
        retval += 11;
    
    return retval;
}

+ (Float32)centDiffInPitch:(NSString*)pitchA with:(NSString*)pitchB
{
    Float32 frequencyA = [PitchInfo midiToFreq:[PitchInfo pitchToMIDI:pitchA]];
    Float32 frequencyB = [PitchInfo midiToFreq:[PitchInfo pitchToMIDI:pitchB]];

    return [PitchInfo centDiffInFreq:frequencyA with:frequencyB];
}
+ (Float32)centDiffInFreq:(Float32)frequencyA with:(Float32)frequencyB
{
    return fabsf(1200*log2f(frequencyB/frequencyA));
}

@end
