//
//  HighScorePage.h
//  TheSingingCoach
//
//  Created by Natalie and Edward on 11/6/14.
//  Copyright (c) 2014 Natalie and Edward. All rights reserved.
//

#import "MainMenu.h"
#import <AVFoundation/AVFoundation.h>
#import <SpriteKit/SpriteKit.h>

@interface HighScorePage : SKScene
{
    AVAudioPlayer*  _player;
    double          _scaleY;
    double          _scaleX;
}

@end
