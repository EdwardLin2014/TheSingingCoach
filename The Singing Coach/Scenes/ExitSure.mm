//
//  ExitSure.mm
//  TheSingingCoach
//
//  Created by Natalie and Edward on 11/6/14.
//  Copyright (c) 2014 Natalie and Edward. All rights reserved.
//

#import "ExitSure.h"

@implementation ExitSure

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        _scaleX = self.frame.size.width/1136;
        _scaleY = self.frame.size.height/640;
        
        SKSpriteNode *BG  = [SKSpriteNode spriteNodeWithImageNamed:@"exitSure.png"];
        BG.anchorPoint = CGPointMake(0,0);
        BG.position = CGPointMake(0, 0);
        BG.xScale = _scaleX;
        BG.yScale = _scaleY;
        
        [self addChild:BG];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSError *err;
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"button" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    
    if(err)
        NSLog(@"Cannot Load Audio.");
    
    CGPoint location =[ [touches anyObject] locationInNode:self];
    CGRect yes = CGRectMake(188 *2* _scaleX, (320-184)*2 * _scaleY   , 66 *2*_scaleX, 31*2 * _scaleY);
    
    CGRect no = CGRectMake(329*2 * _scaleX, (320-183)*2*_scaleY, 66 *2*_scaleX, 33*2 * _scaleY);
    
    if(CGRectContainsPoint(yes, location))
        exit(0);
    else if (CGRectContainsPoint(no, location))
    {
        SKScene *main = [MainMenu sceneWithSize:self.size];
        [_player play];
        [self.view presentScene:main transition:[SKTransition crossFadeWithDuration:0.2]];
    }
}

@end
