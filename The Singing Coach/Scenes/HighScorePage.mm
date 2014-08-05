//
//  HighScorePage.m
//  TheSingingCoach
//
//  Created by Natalie and Edward on 11/6/14.
//  Copyright (c) 2014 Natalie and Edward. All rights reserved.
//

#import "HighScorePage.h"

@implementation HighScorePage

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        _scaleX = self.frame.size.width/1136;
        _scaleY = self.frame.size.height/640;
        self.backgroundColor = [UIColor whiteColor];
        
        SKSpriteNode *BG  = [SKSpriteNode spriteNodeWithImageNamed:@"SelectSong.png"];
        BG.anchorPoint = CGPointMake(0,0);
        BG.position = CGPointMake(0, 0);
        BG.xScale = _scaleX;
        BG.yScale = _scaleY;
        [self addChild:BG];
        [self setupScores];
        
    }
    return self;
}

-(void)setupScores
{
    NSUserDefaults* userDefs = [NSUserDefaults standardUserDefaults];
  
    SKSpriteNode *Chandelier = [SKSpriteNode spriteNodeWithImageNamed:@"Chandelier.png"];
    Chandelier.anchorPoint = CGPointMake(0,0);
    Chandelier.position =CGPointMake(95*2*_scaleX,_scaleY*2*(320-109));
    Chandelier.xScale = _scaleX;
    Chandelier.yScale = _scaleY;
    [self addChild:Chandelier];
    
    double HSChandelier = [userDefs doubleForKey:@"highScore1"];
    SKLabelNode* scoreValueChandelier = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Roman"];
    scoreValueChandelier.text = [NSString stringWithFormat:@"%f", HSChandelier];
    scoreValueChandelier.fontSize = 20;
    scoreValueChandelier.fontColor = [UIColor blackColor];
    scoreValueChandelier.position =CGPointMake(354*2*_scaleX, _scaleY*2*(320-107));
    scoreValueChandelier.zPosition = 1;
    scoreValueChandelier.xScale = _scaleX;
    scoreValueChandelier.yScale = _scaleY;
    [self addChild:scoreValueChandelier];
    
    SKSpriteNode *CustomSong = [SKSpriteNode spriteNodeWithImageNamed:@"cusSong.png"];
    CustomSong.anchorPoint = CGPointMake(0, 0);
    CustomSong.position = CGPointMake(94*2*_scaleX, (320-43)*2*_scaleY);
    CustomSong.xScale = _scaleX;
    CustomSong.yScale = _scaleY;
    [self addChild:CustomSong];
    
    double HSCustomSong = [userDefs doubleForKey:@"highScore0"];
    SKLabelNode* scoreValueCustSong = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Roman"];
    scoreValueCustSong.text = [NSString stringWithFormat:@"%f", HSCustomSong];
    scoreValueCustSong.fontSize = 20;
    scoreValueCustSong.fontColor = [UIColor blackColor];
    scoreValueCustSong.position = CGPointMake(354*2*_scaleX, (320-40)*2*_scaleY);
    scoreValueCustSong.xScale = _scaleX;
    scoreValueCustSong.yScale = _scaleY;
    scoreValueCustSong.zPosition = 1;
    [self addChild:scoreValueCustSong];
    
    SKSpriteNode *saySomething = [SKSpriteNode spriteNodeWithImageNamed:@"SaySomething.png"];
    saySomething.anchorPoint = CGPointMake(0, 0);
    saySomething.position = CGPointMake(94*2*_scaleX, (320-172)*2*_scaleY);
    saySomething.xScale = _scaleX;
    saySomething.yScale = _scaleY;
    [self addChild:saySomething];
    
    double saySomethingScore = [userDefs doubleForKey:@"highScore2"];
    SKLabelNode* scoreValueSS = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Roman"];
    scoreValueSS.text = [NSString stringWithFormat:@"%f", saySomethingScore];
    scoreValueSS.fontSize = 20;
    scoreValueSS.fontColor = [UIColor blackColor];
    scoreValueSS.position = CGPointMake(354*2*_scaleX, (320-167)*2*_scaleY);
    scoreValueSS.xScale = _scaleX;
    scoreValueSS.yScale = _scaleY;
    scoreValueSS.zPosition = 1;
    [self addChild:scoreValueSS];
    
    SKSpriteNode *wings = [SKSpriteNode spriteNodeWithImageNamed:@"wings.png"];
    wings.anchorPoint = CGPointMake(0, 0);
    wings.position  = CGPointMake( 92*2*_scaleX, (320-240)*2*_scaleY);
    wings.xScale = _scaleX;
    wings.yScale = _scaleY;
    [self addChild:wings];
    
    double wingsScore = [userDefs doubleForKey:@"highScore3"];
    SKLabelNode* scoreValueW= [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Roman"];
    scoreValueW.text = [NSString stringWithFormat:@"%f", wingsScore];
    scoreValueW.fontSize = 20;
    scoreValueW.fontColor = [UIColor blackColor];
    scoreValueW.position = CGPointMake(354*2*_scaleX, (320-235)*2*_scaleY);
    scoreValueW.xScale = _scaleX;
    scoreValueW.yScale = _scaleY;
    scoreValueW.zPosition = 1;
    [self addChild:scoreValueW];
    
    SKSpriteNode* demons = [SKSpriteNode spriteNodeWithImageNamed:@"Demons.png"];
    demons.anchorPoint = CGPointMake(0, 0);
    demons.position = CGPointMake(94*2*_scaleX, (320-301)*2*_scaleY);
    demons.xScale = _scaleX;
    demons.yScale = _scaleY;
    [self addChild:demons];
    
    double demonsScore = [userDefs doubleForKey:@"highScore4"];
    SKLabelNode* scoreValueD = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Roman"];
    scoreValueD.text = [NSString stringWithFormat:@"%f", demonsScore];
    scoreValueD.fontSize = 20;
    scoreValueD.fontColor = [UIColor blackColor];
    scoreValueD.position = CGPointMake(354*2*_scaleX, (320-302)*2*_scaleY);
    scoreValueD.xScale = _scaleX;
    scoreValueD.yScale = _scaleY;
    scoreValueD.zPosition = 1;
    [self addChild:scoreValueD];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint location =[ [touches anyObject] locationInNode:self];
    NSError* err;
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"button" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    
    CGRect exitButton = CGRectMake(0, (320-86)*2*_scaleY, 74*2*_scaleX , 86*2*_scaleY);
    
    if (CGRectContainsPoint(exitButton, location))
    {
        if (err)
            NSLog(@"Cannot Load audio");
        else
        {
            [_player play];
            
            SKScene* scene = [MainMenu sceneWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            [self.view presentScene:scene transition:[SKTransition fadeWithDuration:1.5f]];
        }
    }
}

@end
