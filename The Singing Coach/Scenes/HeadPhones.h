//
//  HeadPhones.h
//  TheSingingCoach
//
//  Created by Natalie and Edward on 11/6/14.
//  Copyright (c) 2014 Natalie and Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SongScene.h"


@interface HeadPhones : SKScene
{
    SKSpriteNode*   _headPhones;
    SKSpriteNode*   _beginOverlay;
    int             _hpState;
    int             _displayed;
    int             _yesDisplayed;
    NSString*       _songName;
    float           _tempoInput;
    float           _delay;
    NSMutableArray* _input;
    float           _C3Position;
    NSString*       _pianoName;
    NSString*       _lyricsName;
    float           _lyricsDuration;
}

/* -----------------------------Public Methods--------------------------------- Begin */
-(id)initWithSize:(CGSize)size
     withSongName:(NSString*)songName
        withTempo: (float)tempoInput
        withDelay: (float)delay
        withInput: (NSMutableArray*)input
       withC3YPos: (float)C3Position
    withPianoName:(NSString*)pianoName
       withLyrics:(NSString *)lyricsName
withLyricsDuration:(float)lyricsDuration;

/* -----------------------------Public Methods--------------------------------- End */

/* -----------------------------Private Methods--------------------------------- Begin */

- (BOOL)isHeadsetPluggedIn;
/* -----------------------------Private Methods--------------------------------- End */


@end
