//
//  MainMenu.mm
//  TheSingingCoach
//
//  Created by Natalie and Edward on 11/6/14.
//  Copyright (c) 2014 Natalie and Edward. All rights reserved.
//
#import "MainMenu.h"
@implementation MainMenu

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        _scaleX = self.frame.size.width/1136;
        _scaleY = self.frame.size.height/640;
        
        SKSpriteNode *BG  = [SKSpriteNode spriteNodeWithImageNamed:@"MainMenuPic.png"];
        BG.anchorPoint = CGPointMake(0,0);
        BG.position = CGPointMake(0, 0);
        BG.yScale = _scaleY;
        BG.xScale = _scaleX;
        [self addChild:BG];
        
        _PlayerNameOverlay = [SKSpriteNode spriteNodeWithImageNamed:@"EnterPlayerName.png"];
        _PlayerNameOverlay.anchorPoint = CGPointMake(0, 0);
        _PlayerNameOverlay.position = CGPointMake(0, 0);
        _PlayerNameOverlay.xScale = _scaleX;
        _PlayerNameOverlay.yScale = _scaleY;
        _PNstate = 0;
        
        _userDefs = [NSUserDefaults standardUserDefaults];
        _myName = [_userDefs stringForKey:@"myname"];
        
        if (_myName == nil)
        {
            _myName = @"not set";
            [_userDefs setObject:_myName forKey:@"myname"];
        }
        
        _PlayerNameText = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Roman"];
        _PlayerNameText.text = _myName;
        _PlayerNameText.position = CGPointMake(2*243*_scaleX, (320-290)*2*_scaleY);
        _PlayerNameText.fontSize = 20*_scaleY*2;
        _PlayerNameText.fontColor = [UIColor blackColor];
        _PlayerNameText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _PlayerNameText.xScale = _scaleX;
        _PlayerNameText.yScale = _scaleY;
        [self addChild:_PlayerNameText];
        
        [self setupTextField];
        
    }
    return self;
}

-(void) setupTextField
{
    _textField = [[UITextField alloc]initWithFrame:[self fieldRect]];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont fontWithName:@"IowanOldStyle-Roman" size:20*2*_scaleY ];
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.placeholder = @"Enter player name";
    _textField.tintColor = [UIColor blackColor];
    _textField.delegate = self;
}

- (BOOL)textField:(UITextField *)textField
        shouldChangeCharactersInRange:(NSRange)range
        replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 20) ? NO : YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [self processReturn];
    return YES;
}

-(void) processReturn
{
    [_textField resignFirstResponder];
    NSString* textValue = _textField.text;
    
    if([textValue compare:@""] != 0)
    {
        _myName = textValue;
        _PNstate = 0;
        [_textField removeFromSuperview];
        [_PlayerNameOverlay removeFromParent];
        [_PlayerNameText removeFromParent];
        _PlayerNameText = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Roman"];
        _PlayerNameText.text = _myName;
        _PlayerNameText.position = CGPointMake(243*2*_scaleX, (320-290)*2*_scaleY);
        _PlayerNameText.fontSize = 20*2*_scaleY;
        _PlayerNameText.fontColor = [UIColor blackColor];
        _PlayerNameText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _PlayerNameText.xScale = _scaleX;
        _PlayerNameText.yScale = _scaleY;
        [self addChild:_PlayerNameText];
        [_userDefs setObject:_myName forKey:@"myname"];
    }
    
}

-(CGRect)fieldRect
{
    return CGRectMake(168*2*_scaleX, 118*2*_scaleY, 235*2*_scaleX, 26*2*_scaleY);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location =[ [touches anyObject] locationInNode:self];
    CGRect SelectButton = CGRectMake(77*2*_scaleX, (320-144)*2*_scaleY, 232*2*_scaleX , 35*2*_scaleY );
    CGRect HighScoreButton = CGRectMake(79*2*_scaleX, (320-211)*2*_scaleY, 230*2*_scaleX, 38*2*_scaleY);
    CGRect exitButton = CGRectMake(0, (320-86)*2*_scaleY, 74*2*_scaleX  , 86*2*_scaleY);
    CGRect playerNameButton = CGRectMake(86*2*_scaleX, (320-311)*2*_scaleY, 50*2*_scaleX, 48*2*_scaleY);
    
    NSError *err;
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"button" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _ButtonSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    
    if (err)
        NSLog(@"Cannot load audio");
    
    if (_PNstate == 0)
    {
        if (CGRectContainsPoint(SelectButton, location))
        {
            SKScene * scene = [SongChooseMenu sceneWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [_ButtonSound play];
            [self.view presentScene:scene transition:[SKTransition fadeWithDuration:1.5]];
        }
        else if (CGRectContainsPoint(exitButton, location))
        {
            [_ButtonSound play];
            
            SKScene* scene = [ExitSure sceneWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            [self.view presentScene:scene transition:[SKTransition crossFadeWithDuration:0.2]];
        }
        else if (CGRectContainsPoint(HighScoreButton, location))
        {
            [_ButtonSound play];
            
            SKScene* scene =[HighScorePage sceneWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            [self.view presentScene:scene transition:[SKTransition fadeWithDuration:1.5f]];
        }
        else if (CGRectContainsPoint(playerNameButton, location))
        {
            [_ButtonSound play];
            [self addChild:_PlayerNameOverlay];
            [self.view addSubview:_textField];
            _PNstate = 1;
        }
    }
    else if (_PNstate == 1)
    {
        CGRect exitPN = CGRectMake(337*2*_scaleX, _scaleY*2*(320-198), 83*2*_scaleX, 23*2*_scaleY);
        
        if (CGRectContainsPoint(exitPN, location))
        {
            [_ButtonSound play];
            [_textField removeFromSuperview];
            [_PlayerNameOverlay removeFromParent];
            _PNstate = 0;
        }
    }
}

@end
