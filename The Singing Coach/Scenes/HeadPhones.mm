//
//  HeadPhones.m
//  TheSingingCoach
//
//  Created by Natalie and Edward on 11/6/14.
//  Copyright (c) 2014 Natalie and Edward. All rights reserved.
//

#import "HeadPhones.h"

@implementation HeadPhones

-(id)initWithSize:(CGSize)size
     withSongName:(NSString*)songName
        withTempo: (float)tempoInput
        withDelay: (float)delay
        withInput: (NSMutableArray*)input
       withC3YPos: (float)C3Position
    withPianoName:(NSString*)pianoName
       withLyrics:(NSString*)lyricsName
withLyricsDuration:(float)lyricsDuration
{
    if (self = [super initWithSize:size])
    {
        _scaleX = self.frame.size.width/1136;
        _scaleY = self.frame.size.height/640;
        
        _songName = songName;
        _tempoInput = tempoInput;
        _delay = delay;
        _input = input;
        _C3Position = C3Position;
        _pianoName = pianoName;
        _lyricsName = lyricsName;
        _lyricsDuration = lyricsDuration;
        
        self.backgroundColor = [UIColor blackColor];
        _headPhones = [SKSpriteNode spriteNodeWithImageNamed:@"PauseOverlayHeadphone.png"];
        _headPhones.anchorPoint = CGPointMake(0, 0);
        _headPhones.position = CGPointMake(0, 0);
        _headPhones.zPosition = 5;
        _headPhones.xScale = _scaleX;
        _headPhones.yScale = _scaleY;
        
        _beginOverlay = [SKSpriteNode spriteNodeWithImageNamed:@"BeginOverlay.png"];
        _beginOverlay.anchorPoint = CGPointMake(0, 0);
        _beginOverlay.position = CGPointMake(0, 0);
        _beginOverlay.zPosition = 5;
        _beginOverlay.xScale = _scaleX;
        _beginOverlay.yScale = _scaleY;
        
        _hpState = 0;
        _displayed = 0;
        _yesDisplayed = 0;
    }
    return self;
}

- (void)update:(NSTimeInterval)currentTime
{
    
    if(_hpState == 0)
    {
        BOOL value = [self isHeadsetPluggedIn];
        if (value == true && _yesDisplayed == 0)
        {
            [_headPhones removeFromParent];
            [self addChild:_beginOverlay];
            _yesDisplayed = 1;
            _hpState = 1;
        }
        else if (value==true && _yesDisplayed == 1)
            _hpState = 1;
        else if (value == false)
        {
            if ( _displayed == 0)
            {
                [self addChild:_headPhones];
                _displayed = 1;
            }
        }
    }
}

- (BOOL)isHeadsetPluggedIn
{
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs])
    {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_hpState == 1)
    {
        SKScene *songScene = [[SongScene alloc]initWithSize:self.size withSongName:_songName withTempo:_tempoInput withDelay:_delay withInput:_input withC3YPos:_C3Position withPianoName:_pianoName withLyrics:_lyricsName withLyricsDuration:_lyricsDuration];
        songScene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:songScene transition:[SKTransition fadeWithDuration:1.5f]];
    }
    
}

@end
