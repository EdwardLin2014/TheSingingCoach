//
//  SongChooseMenu.mm
//  TheSingingCoach
//
//  Created by Natalie and Edward on 11/6/14.
//  Copyright (c) 2014 Natalie and Edward. All rights reserved.
//

#import "SongChooseMenu.h"

@implementation SongChooseMenu

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        _scaleY = size.height / 640;
        _scaleX = size.width / 1136;
        
        _userDefs = [NSUserDefaults standardUserDefaults];
        
        _cusSongState = 0;
        _listenButtonChandelierState = 0;
        _fileNotFound = 0;
        _SaySomethingListenState = 0;
        _WingsListenState = 0;
        _DemonsListenState = 0;
        
        self.backgroundColor = [UIColor whiteColor];
        
        SKSpriteNode *BG  = [SKSpriteNode spriteNodeWithImageNamed:@"SelectSong.png"];
        BG.anchorPoint = CGPointMake(0,0);
        BG.position = CGPointMake(0, 0);
        BG.xScale = _scaleX;
        BG.yScale = _scaleY;
        [self addChild:BG];
        
        SKSpriteNode *Chandelier = [SKSpriteNode spriteNodeWithImageNamed:@"Chandelier.png"];
        Chandelier.anchorPoint = CGPointMake(0,0);
        Chandelier.position = CGPointMake(94*2*_scaleX,(320-109)*2*_scaleY);
        Chandelier.xScale = _scaleX;
        Chandelier.yScale = _scaleY;
        [self addChild:Chandelier];
        
        _ChandelierListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"ListenOff.png"];
        _ChandelierListenNode.anchorPoint = CGPointMake(0, 0);
        _ChandelierListenNode.position = CGPointMake(320*2*_scaleX , (320 -111)*2*_scaleY);
        _ChandelierListenNode.name = @"ChandelierListenNode";
        _ChandelierListenNode.xScale = _scaleX;
        _ChandelierListenNode.yScale = _scaleY;
        [self addChild:_ChandelierListenNode];
        
        SKSpriteNode *saySomething = [SKSpriteNode spriteNodeWithImageNamed:@"SaySomething.png"];
        saySomething.anchorPoint = CGPointMake(0, 0);
        saySomething.position = CGPointMake(94*2*_scaleX, (320-172)*2*_scaleY);
        saySomething.xScale = _scaleX;
        saySomething.yScale = _scaleY;
        [self addChild:saySomething];
        
        _SaySomethingListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"ListenOff.png"];
        _SaySomethingListenNode.anchorPoint = CGPointMake(0, 0);
        _SaySomethingListenNode.position = CGPointMake(320*2*_scaleX, (320-173)*2*_scaleY);
        _SaySomethingListenNode.xScale = _scaleX;
        _SaySomethingListenNode.yScale = _scaleY;
        [self addChild:_SaySomethingListenNode];
        
        SKSpriteNode *wings = [SKSpriteNode spriteNodeWithImageNamed:@"wings.png"];
        wings.anchorPoint = CGPointMake(0, 0);
        wings.position  = CGPointMake( 92*2*_scaleX, (320-240)*2*_scaleY);
        wings.xScale = _scaleX;
        wings.yScale = _scaleY;
        [self addChild:wings];
        
        _DemonsListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"ListenOff.png"];
        _DemonsListenNode.anchorPoint = CGPointMake(0, 0);
        _DemonsListenNode.position = CGPointMake(320*2*_scaleX, (320-307)*2*_scaleY);
        _DemonsListenNode.xScale = _scaleX;
        _DemonsListenNode.yScale = _scaleY;
        [self addChild:_DemonsListenNode];
        
        _WingsListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"ListenOff.png"];
        _WingsListenNode.anchorPoint = CGPointMake(0, 0);
        _WingsListenNode.position = CGPointMake(320*2*_scaleX, (320-241)*2*_scaleY);
        _WingsListenNode.xScale = _scaleX;
        _WingsListenNode.yScale = _scaleY;
        [self addChild:_WingsListenNode];
        
        SKSpriteNode* demons = [SKSpriteNode spriteNodeWithImageNamed:@"Demons.png"];
        demons.anchorPoint = CGPointMake(0, 0);
        demons.position = CGPointMake(94*2*_scaleX, (320-301)*2*_scaleY);
        demons.xScale = _scaleX;
        demons.yScale = _scaleY;
        [self addChild:demons];
        
        SKSpriteNode *CustomSong = [SKSpriteNode spriteNodeWithImageNamed:@"CustomSong.png"];
        CustomSong.anchorPoint = CGPointMake(0, 0);
        CustomSong.position = CGPointMake(94*2*_scaleX, (320-43)*2*_scaleY);
        CustomSong.xScale = _scaleX;
        CustomSong.yScale = _scaleY;
        [self addChild:CustomSong];
        
        _customSongOvr = [SKSpriteNode spriteNodeWithImageNamed:@"customSongOverlay.png"];
        _customSongOvr.anchorPoint = CGPointMake(0, 0);
        _customSongOvr.position = CGPointMake(0, 0);
        _customSongOvr.xScale = _scaleX;
        _customSongOvr.yScale = _scaleY;
        [self setupTextField];
        
        _FileNotFound = [SKSpriteNode spriteNodeWithImageNamed:@"filenotfound.png"];
        _FileNotFound.anchorPoint = CGPointMake(0, 0);
        _FileNotFound.position = CGPointMake(0, 0);
        _FileNotFound.xScale = _scaleX;
        _FileNotFound.yScale = _scaleY;
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
    _textField.placeholder = @"Enter file name";
    _textField.tintColor = [UIColor blackColor];
    _textField.delegate = self;
}

-(BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    [self processReturn];
    return YES;
}

-(void) processReturn
{
    [_textField resignFirstResponder];
    
    if ([_textField.text compare:@""] != 0)
    {
        NSError *error;
        NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* docsDir = [dirPaths[0] stringByAppendingString:@"/"];
        NSString* filePath = [[docsDir stringByAppendingString:_textField.text] stringByAppendingString:@".txt"];
        NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        
        if (error)
        {
            NSLog(@"Error reading file: %@", error.localizedDescription);
            NSLog(@"filePath: %@", filePath);
            _fileNotFound = 1;
            [_textField removeFromSuperview];
            [self addChild:_FileNotFound];
        }
        else
        {
            [_textField removeFromSuperview];
            
            NSMutableArray *listArray = [NSMutableArray arrayWithArray:[fileContents componentsSeparatedByString:@"\n"]];
            NSString *lyricsName = [listArray objectAtIndex:0];
            [listArray removeObjectAtIndex:0];
            NSString* lyricsDuration = [listArray objectAtIndex:0];
            [listArray removeObjectAtIndex:0];
            float lyricsDurationfloat = [lyricsDuration floatValue];
            NSString *pianoName = [listArray objectAtIndex:0];
            [listArray removeObjectAtIndex:0];
            float C3YPos = [self getC3YPos:pianoName];
            NSString *songName = [listArray objectAtIndex:0];
            [listArray removeObjectAtIndex:0];
            NSString *tempoString = [listArray objectAtIndex:0];
            float tempo = [tempoString floatValue];
            [listArray removeObjectAtIndex:0];
            NSString *delayString = [listArray objectAtIndex:0];
            float delay = [delayString floatValue];
            [listArray removeObjectAtIndex:0];
            
            SKScene *customSongScene = [[HeadPhones alloc]initWithSize:self.size
                                                          withSongName:songName
                                                             withTempo:tempo
                                                             withDelay:delay
                                                             withInput:listArray
                                                            withC3YPos:C3YPos
                                                         withPianoName:pianoName
                                                            withLyrics:lyricsName
                                                    withLyricsDuration:lyricsDurationfloat];
            customSongScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:customSongScene transition:[SKTransition fadeWithDuration:1.5f]];
        }
    }
}


-(CGRect)fieldRect
{
    return CGRectMake(168*2*_scaleX, 118*2*_scaleY, 235*2*_scaleX, 26*2*_scaleY);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location =[ [touches anyObject] locationInNode:self];
    NSError* err;
    NSString* path  = [[NSBundle mainBundle] pathForResource:@"button" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    
    if (err)
        NSLog (@"Cannot Load audio");
    
    if (_fileNotFound == 0)
    {
        if (_cusSongState == 0)
        {
            CGRect Chandelier = CGRectMake(78*2*_scaleX, (320-126)*2*_scaleY, 200*2*_scaleX, 64*2*_scaleY);
            CGRect ChandelierListen = CGRectMake(320*2*_scaleX, (320-111)*2*_scaleY,60*2*_scaleX,60*2*_scaleY);
            
            CGRect SaySomething = CGRectMake(78*2*_scaleX, (320-190)*2*_scaleY, 200*2*_scaleX, 64*2*_scaleY);
            CGRect SaySomethingListen = CGRectMake(320*2*_scaleX, (320-173)*2*_scaleY, 60*2*_scaleX, 60*2*_scaleY);
            
            CGRect Wings = CGRectMake(78*2*_scaleX, (320-255)*2*_scaleY, 200*2*_scaleX, 64*2*_scaleY);
            CGRect WingsListen = CGRectMake(320*2*_scaleX, (320-241)*2*_scaleY, 60*2*_scaleX, 60*2*_scaleY);
            
            NSString* ChandelierPath = [[NSBundle mainBundle] pathForResource:@"chandelier" ofType:@"mp3"];
            NSURL* ChandelierURL = [NSURL fileURLWithPath:ChandelierPath];
            
            NSString* saysomethingPath = [[NSBundle mainBundle] pathForResource:@"saysomething" ofType:@"mp3"];
            NSURL* SaySomethingURL = [NSURL fileURLWithPath:saysomethingPath];
            
            NSString* WingsPath = [[NSBundle mainBundle] pathForResource:@"wings" ofType:@"mp3"];
            NSURL* WingsURL = [NSURL fileURLWithPath:WingsPath];
            
            CGRect Demons = CGRectMake(78*2*_scaleX, 0, 200*2*_scaleX, 64*2*_scaleY);
            CGRect DemonsListen = CGRectMake(320*2*_scaleX, (320-307)*2*_scaleY, 60*2*_scaleX, 60*2*_scaleY);
            
            NSString* DemonsPath = [[NSBundle mainBundle]pathForResource:@"demons" ofType:@"mp3"];
            NSURL* DemonsURL = [NSURL fileURLWithPath:DemonsPath];
            
            CGRect CustomSong = CGRectMake(78*2*_scaleX,( 320-62)*2*_scaleY, 323*2*_scaleX, 64*2*_scaleY);
            CGRect exitButton = CGRectMake(0*2*_scaleX, (320-86)*2*_scaleY, 74*2*_scaleX  , 86*2*_scaleY);
            
            if (CGRectContainsPoint(Demons, location))
            {
                [_userDefs setInteger:4 forKey:@"songType"];
                [_listenDemons stop];
                [_player play];
                
                NSString *fileName = @"imagineDragons";
                NSString *filepath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
                NSError *error;
                NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
                
                if (error)
                {
                    NSLog(@"Error reading file: %@", error.localizedDescription);
                    _fileNotFound = 1;
                    [_textField removeFromSuperview];
                    [self addChild:_FileNotFound];
                }
                else
                {
                    NSMutableArray* listArray = [NSMutableArray arrayWithArray:[fileContents componentsSeparatedByString:@"\n"]];
                    NSString* lyricsName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    NSString* lyricsDuration = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    float lyricsDurationFloat = [lyricsDuration floatValue];
                    NSString* pianoName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    float C3YPos = [self getC3YPos:pianoName];
                    NSString* songName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    NSString* tempoString = [listArray objectAtIndex:0];
                    float tempo = [tempoString floatValue];
                    [listArray removeObjectAtIndex:0];
                    NSString* delayString = [listArray objectAtIndex:0];
                    float delay = [delayString floatValue];
                    [listArray removeObjectAtIndex:0];
                    
                    SKScene* SongScene = [[HeadPhones alloc]initWithSize:self.size
                                                            withSongName:songName
                                                               withTempo:tempo
                                                               withDelay:delay
                                                               withInput:listArray
                                                              withC3YPos:C3YPos
                                                           withPianoName:pianoName
                                                              withLyrics:lyricsName
                                                      withLyricsDuration:lyricsDurationFloat];
                    SongScene.scaleMode = SKSceneScaleModeAspectFill;
                    [self.view presentScene:SongScene transition:[SKTransition fadeWithDuration:1.5f]];
                }
            }
            if (CGRectContainsPoint(Chandelier, location))
            {
                [_userDefs setInteger:1 forKey:@"songType"];
                [_player play];
                [_listen stop];

                NSString *fileName = @"chandelierSia";
                NSString *filepath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
                NSError *error;
                NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
                
                if (error)
                {
                    NSLog(@"Error reading file: %@", error.localizedDescription);
                    _fileNotFound = 1;
                    [_textField removeFromSuperview];
                    [self addChild:_FileNotFound];
                }
                else
                {
                    NSMutableArray* listArray = [NSMutableArray arrayWithArray:[fileContents componentsSeparatedByString:@"\n"]];
                    NSString* lyricsName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    NSString* lyricsDuration = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    float lyricsDurationFloat = [lyricsDuration floatValue];
                    NSString* pianoName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    float C3YPos = [self getC3YPos:pianoName];
                    NSString* songName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    NSString* tempoString = [listArray objectAtIndex:0];
                    float tempo = [tempoString floatValue];
                    [listArray removeObjectAtIndex:0];
                    NSString* delayString = [listArray objectAtIndex:0];
                    float delay = [delayString floatValue];
                    [listArray removeObjectAtIndex:0];
                    
                    SKScene* SongScene = [[HeadPhones alloc]initWithSize:self.size
                                                            withSongName:songName
                                                               withTempo:tempo
                                                               withDelay:delay
                                                               withInput:listArray
                                                              withC3YPos:C3YPos
                                                           withPianoName:pianoName
                                                              withLyrics:lyricsName
                                                      withLyricsDuration:lyricsDurationFloat];
                    SongScene.scaleMode = SKSceneScaleModeAspectFill;
                    [self.view presentScene:SongScene transition:[SKTransition fadeWithDuration:1.5f]];
                }
            }
            else if (CGRectContainsPoint(Wings, location))
            {
                [_userDefs setInteger:3 forKey:@"songType"];
                [_player play];
                [_listenWings stop];
                
                NSString *fileName = @"birdy";
                NSString *filepath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
                NSError *error;
                NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
                
                if (error)
                {
                    NSLog(@"Error reading file: %@", error.localizedDescription);
                }
                else
                {
                    NSMutableArray* listArray = [NSMutableArray arrayWithArray:[fileContents componentsSeparatedByString:@"\n"]];
                    NSString* lyricsName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    NSString* lyricsDuration = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    float lyricsDurationFloat = [lyricsDuration floatValue];
                    NSString* pianoName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    float C3YPos = [self getC3YPos:pianoName];
                    NSString* songName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    NSString* tempoString = [listArray objectAtIndex:0];
                    float tempo = [tempoString floatValue];
                    [listArray removeObjectAtIndex:0];
                    NSString* delayString = [listArray objectAtIndex:0];
                    float delay = [delayString floatValue];
                    [listArray removeObjectAtIndex:0];
                    
                    SKScene* SongScene = [[HeadPhones alloc]initWithSize:self.size
                                                            withSongName:songName
                                                               withTempo:tempo
                                                               withDelay:delay
                                                               withInput:listArray
                                                              withC3YPos:C3YPos
                                                           withPianoName:pianoName
                                                              withLyrics:lyricsName
                                                      withLyricsDuration:lyricsDurationFloat];
                    SongScene.scaleMode = SKSceneScaleModeAspectFill;
                    [self.view presentScene:SongScene transition:[SKTransition fadeWithDuration:1.5f]];
                }
            }
            else if (CGRectContainsPoint(SaySomething, location))
            {
                [_userDefs setInteger:2 forKey:@"songType"];
                [_player play];
                [_listenSaySomething stop];
                
                NSString *fileName = @"saysomething";
                NSString *filepath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
                NSError *error;
                NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
                
                if (error)
                {
                    NSLog(@"Error reading file: %@", error.localizedDescription);
                }
                else
                {
                    NSMutableArray* listArray = [NSMutableArray arrayWithArray:[fileContents componentsSeparatedByString:@"\n"]];
                    NSString* lyricsName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    NSString* lyricsDuration = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    float lyricsDurationFloat = [lyricsDuration floatValue];
                    NSString* pianoName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    float C3YPos = [self getC3YPos:pianoName];
                    NSString* songName = [listArray objectAtIndex:0];
                    [listArray removeObjectAtIndex:0];
                    NSString* tempoString = [listArray objectAtIndex:0];
                    float tempo = [tempoString floatValue];
                    [listArray removeObjectAtIndex:0];
                    NSString* delayString = [listArray objectAtIndex:0];
                    float delay = [delayString floatValue];
                    [listArray removeObjectAtIndex:0];
                    
                    SKScene* SongScene = [[HeadPhones alloc]initWithSize:self.size
                                                            withSongName:songName
                                                               withTempo:tempo
                                                               withDelay:delay
                                                               withInput:listArray
                                                              withC3YPos:C3YPos
                                                           withPianoName:pianoName
                                                              withLyrics:lyricsName
                                                      withLyricsDuration:lyricsDurationFloat];
                    SongScene.scaleMode = SKSceneScaleModeAspectFill;
                    [self.view presentScene:SongScene transition:[SKTransition fadeWithDuration:1.5f]];
                }
            }
            else if (CGRectContainsPoint(SaySomethingListen, location) && _SaySomethingListenState == 0)
            {
                _listenSaySomething = [[AVAudioPlayer alloc]initWithContentsOfURL:SaySomethingURL error:&err];
                if (err)
                    NSLog(@"Cannot load audio");
                else
                {
                    _SaySomethingListenState = 1;
                    [_SaySomethingListenNode removeFromParent];
                    
                    _SaySomethingListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"Listen.png"];
                    _SaySomethingListenNode.anchorPoint = CGPointMake(0, 0);
                    _SaySomethingListenNode.position = CGPointMake(320*2*_scaleX, (320-173)*2*_scaleY);
                    _SaySomethingListenNode.xScale = _scaleX;
                    _SaySomethingListenNode.yScale = _scaleY;
                    [self addChild:_SaySomethingListenNode];
                    
                    [_listenSaySomething play];
                }
            }
            else if (CGRectContainsPoint(DemonsListen, location) && _DemonsListenState == 0)
            {
                _DemonsListenState = 1;
                _listenDemons = [[AVAudioPlayer alloc]initWithContentsOfURL:DemonsURL error:&err];
                
                [_DemonsListenNode removeFromParent];
                _DemonsListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"Listen.png"];
                _DemonsListenNode.anchorPoint = CGPointMake(0, 0);
                _DemonsListenNode.position = CGPointMake(320*2*_scaleX, (320-307)*2*_scaleY);
                _DemonsListenNode.xScale = _scaleX;
                _DemonsListenNode.yScale = _scaleY;
                [self addChild:_DemonsListenNode];
                
                [_listenDemons play];
            }
            else if (CGRectContainsPoint(DemonsListen, location) && _DemonsListenState == 1)
            {
                _DemonsListenState = 0;
                [_listenDemons stop];
                
                [_DemonsListenNode removeFromParent];
                _DemonsListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"ListenOff.png"];
                _DemonsListenNode.anchorPoint = CGPointMake(0, 0);
                _DemonsListenNode.position = CGPointMake(320*2*_scaleX, (320-307)*2*_scaleY);
                _DemonsListenNode.xScale = _scaleX;
                _DemonsListenNode.yScale = _scaleY;
                [self addChild:_DemonsListenNode];
            }
            else if (CGRectContainsPoint(WingsListen, location) && _WingsListenState == 0)
            {
                _listenWings = [[AVAudioPlayer alloc]initWithContentsOfURL:WingsURL error:&err];
                if (err)
                    NSLog(@"Cannot load audio");
                else
                {
                    _WingsListenState= 1;
                    
                    [_WingsListenNode removeFromParent];
                    _WingsListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"Listen.png"];
                    _WingsListenNode.anchorPoint = CGPointMake(0, 0);
                    _WingsListenNode.position = CGPointMake(320*2*_scaleX, (320-241)*2*_scaleY);
                    _WingsListenNode.xScale = _scaleX;
                    _WingsListenNode.yScale = _scaleY;
                    [self addChild:_WingsListenNode];
                    
                    [_listenWings play];
                }
            }
            else if (CGRectContainsPoint(WingsListen, location) && _WingsListenState == 1)
            {
                _WingsListenState = 0;
                
                [_WingsListenNode removeFromParent];
                _WingsListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"ListenOff.png"];
                _WingsListenNode.anchorPoint = CGPointMake(0, 0);
                _WingsListenNode.position = CGPointMake(320*2*_scaleX, (320-241)*2*_scaleY);
                _WingsListenNode.xScale = _scaleX;
                _WingsListenNode.yScale = _scaleY;
                [self addChild:_WingsListenNode];
                
                [_listenWings stop];
            }
            else if (CGRectContainsPoint(ChandelierListen, location) && _listenButtonChandelierState == 0)
            {
                _listen = [[AVAudioPlayer alloc]initWithContentsOfURL:ChandelierURL error:&err];
                if (err)
                    NSLog(@"Cannot load audio");
                else
                {
                    _listenButtonChandelierState = 1;
                    
                    SKNode *CLN = [self childNodeWithName:@"ChandelierListenNode"];
                    [CLN removeFromParent];
                    _ChandelierListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"Listen.png"];
                    _ChandelierListenNode.anchorPoint = CGPointMake(0, 0);
                    _ChandelierListenNode.position = CGPointMake(320*2*_scaleX, (320 -111)*2*_scaleY);
                    _ChandelierListenNode.name = @"ChandelierListenNode";
                    _ChandelierListenNode.xScale = _scaleX;
                    _ChandelierListenNode.yScale = _scaleY;
                    [self addChild:_ChandelierListenNode];
                    
                    [_listen play];
                }
            }
            else if (CGRectContainsPoint(SaySomethingListen, location) && _SaySomethingListenState == 1)
            {
                _SaySomethingListenState = 0;
                
                [_SaySomethingListenNode removeFromParent];
                _SaySomethingListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"ListenOff.png"];
                _SaySomethingListenNode.anchorPoint = CGPointMake(0, 0);
                _SaySomethingListenNode.position = CGPointMake(320*2*_scaleX, (320-173)*2*_scaleY);
                _SaySomethingListenNode.xScale = _scaleX;
                _SaySomethingListenNode.yScale = _scaleY;
                [self addChild:_SaySomethingListenNode];
                
                [_listenSaySomething stop];
            }
            else if (CGRectContainsPoint(ChandelierListen, location) && _listenButtonChandelierState == 1)
            {
                _listenButtonChandelierState = 0;
                
                SKNode *CLN = [self childNodeWithName:@"ChandelierListenNode"];
                [CLN removeFromParent];
                _ChandelierListenNode = [SKSpriteNode spriteNodeWithImageNamed:@"ListenOff.png"];
                _ChandelierListenNode.anchorPoint = CGPointMake(0, 0);
                _ChandelierListenNode.position = CGPointMake(320*2*_scaleX, (320 - 111)*2*_scaleY);
                _ChandelierListenNode.name = @"ChandelierListenNode";
                _ChandelierListenNode.xScale = _scaleX;
                _ChandelierListenNode.yScale = _scaleY;
                [self addChild:_ChandelierListenNode];
                
                [_listen stop];
            }
            else if(CGRectContainsPoint(exitButton, location))
            {
                [_player play];
                SKScene *mainMenu = [MainMenu sceneWithSize:self.size];
                mainMenu.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:mainMenu transition:[SKTransition fadeWithDuration:1.5f]];
            
            }
            else if (CGRectContainsPoint(CustomSong, location))
            {
                [_userDefs setInteger:0 forKey:@"songType"];
                _cusSongState = 1;
                [_player play];
                [self addChild:_customSongOvr];
                [self.view addSubview:_textField];
            }
        }
        else
        {
            CGRect exitCusSong = CGRectMake(337*2*_scaleX, (320-198)*2*_scaleY, 83*2*_scaleX, 23*2*_scaleY);
            if (CGRectContainsPoint(exitCusSong, location))
            {
                _cusSongState = 0;
                [_player play];
                [_customSongOvr removeFromParent];
                [_textField removeFromSuperview];
            }
        }
    }
    else if(_fileNotFound == 1)
    {
        CGRect retry = CGRectMake(242*2*_scaleX, (320-198)*2*_scaleY, 84*2*_scaleX, 22*2*_scaleY);
        if (CGRectContainsPoint(retry, location))
        {
            _fileNotFound = 0;
            [_player play];
            _textField.text = @"";
            [self.view addSubview:_textField];
            [_FileNotFound removeFromParent];
        }
    }
}

-(float) getC3YPos:(NSString*)pianoName
{
    if ([pianoName compare:@"pianoA2A4.png"]==0){
        return 640-571;
    }
    else if ([pianoName compare:@"pianoD3D5.png"]==0){
        return -58;
    }
    else if([pianoName compare:@"pianoB2B4.png"]==0){
        return 640-622;
    }
    else if ([pianoName compare:@"pianoG2G4.png"]==0){
        return 640-519;
    }
    else if ([pianoName compare:@"pianoG3G5.png"]==0){
        return -188;
    }
    return 0;
}

@end
