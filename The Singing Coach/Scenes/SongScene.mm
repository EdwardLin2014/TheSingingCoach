//
//  MyScene.mm
//  TheSingingCoach
//
//  Created by Natalie and Edward on 11/6/14.
//  Copyright (c) 2014 Natalie and Edward. All rights reserved.
//
#import "SongScene.h"

//Tasks: Score calculation & highscore storing using NSUserDefault
@implementation SongScene

-(id)initWithSize:(CGSize)size
     withSongName:(NSString*)songName
        withTempo: (float)tempoInput
        withDelay: (float)delay
        withInput: (NSMutableArray*)input
       withC3YPos: (float)C3Position
    withPianoName:(NSString*)pianoName
       withLyrics:(NSString *)lyricsName
withLyricsDuration:(float)lyricsDuration
{
    if (self = [super initWithSize:size])
    {
        _scaleY = size.height / 640;
        _scaleX = size.width / 1136;
        
        //Set Global variables based on input
        _C3Ypos = C3Position;
        _songName = songName;
        _delay = delay;
        _pianoName = pianoName;
        _tempo = tempoInput;
        _LyricsName = lyricsName;
        _lyricsDuration = lyricsDuration;
        _framesize = self.size;
        _currTime = CACurrentMediaTime();
        
        self.backgroundColor = [SKColor whiteColor];
        
        //Setup initial variables
        [self startApp:pianoName];
        [self startPitch];
        
        //Calculating delay time based on tempo and delay of the song
        float distanceToGo = _framesize.width - _scoreBarXpos;
        float timeToReach = distanceToGo / _speed;
        double totalDelayTime = (double)(_loading + timeToReach - delay);
        
        //Condition to check if the intro is too long, add loading time
        if(totalDelayTime < 0)
        {
            _loading = _loading - totalDelayTime;
            totalDelayTime = 0;
        }
        
        NSUserDefaults* userDefs = [NSUserDefaults standardUserDefaults];
        NSInteger songType = [userDefs integerForKey:@"songType"];
        
        if(songType == 0)
            [self playMusicCustom:songName withShortStartDelay:totalDelayTime];
        else
            [self playMusic:songName withShortStartDelay:totalDelayTime];
        
        [self MakeArrow];
        _StringInput = input;
        
        //Lexing the string input to noteOutput and noteInput and making noteClass objects
        for (int i = 0; i< _StringInput.count; i++)
        {
            //get the note
            NSString *_note = [_StringInput objectAtIndex:i];
            //split by space
            NSArray *_notes = [_note componentsSeparatedByString:@" "];
            //get the length
            if (_notes.count < 2)
                NSLog(@"Invalid input format");
            else
            {
                NSString *_length = [_notes objectAtIndex:0];
                float lth = [_length floatValue];
                _note = [_notes objectAtIndex:1];
                int noteDistance = [self getNoteDistance:_note];
                float yPos = (_C3Ypos + 13*2 * noteDistance + 1)*_scaleY;
                if([_note compare:@"rest"])
                {
                    _songLength = _songLength + (double)lth;
                    SKSpriteNode *noteBox = [_NoteBox copy];
                    noteBox.anchorPoint = CGPointMake(0, 0);
                    noteBox.position = CGPointMake(_framesize.width - lth, yPos);
                    noteBox.xScale = lth * _scaleX;
                    float length = lth * _oneBeatLength;
                    NoteClass *n = [[NoteClass alloc]initWithNote:noteBox withPitch:_note withLength:length withLocation:yPos];
                    [_NoteInput addObject:n];
                }
                else
                {
                    SKSpriteNode *noteBox = [_NoteBox copy];
                    noteBox.anchorPoint = CGPointMake(0, 0);
                    noteBox.position = CGPointMake(_framesize.width - lth, yPos);
                    noteBox.color = [UIColor redColor];
                    noteBox.xScale = lth;
                    float length = lth * _oneBeatLength;
                    NoteClass *n = [[NoteClass alloc]initWithNote:noteBox withPitch:_note withLength:length withLocation:yPos];
                    noteBox.hidden = YES;
                    [_NoteInput addObject:n];
                }
            }
        }
        _FrontNode = [_NoteInput objectAtIndex:0];
        _HittingNode = [_NoteInput objectAtIndex:0];
        _SparkledNode = [_NoteInput objectAtIndex:0];
        double totalTime = _secPerBeat * _songLength;
        double updateTime = totalTime * 58;
        _predictedTotalScore = updateTime;
        
        [self setupLyrics:lyricsName withDuration:lyricsDuration];
    }
    return self;
}

//Method for pitch detector initialization
-(void)startPitch
{
    _sampleRate = 44100;
    _framesSize = 4096;
    _audioController = [[AudioController alloc] init:_sampleRate FrameSize:_framesSize OverLap:0.5];
    [_audioController startIOUnit];
    [_audioController startRecording];
}

//Method for Song Player initialization
-(void)startApp:(NSString*)pianoName
{
    _voiceState = 0;
    _doPitch = 0;
    _previousPitch = @"";
    _pitch = @"D4";
    
    _scoreUpdate = 1;
    _predictedTotalScore = 0;
    _songLength = 0;
    _currentScore = 0;
    _myScore=0;
    _totalCurrentscore=0;
    _totalscore = 0;
    _SparkleIdx = 1;
    _songIsOver = 0;
    _isPausedScene = 0;
    _statusGo = 0;
    _loading  = 2;
    _firstColision = 0;
    
    _NoteBox = [SKSpriteNode spriteNodeWithImageNamed:@"1beat.png"];
    _NoteBox.xScale = _scaleX;
    _NoteBox.yScale = _scaleY;
    
    _oneBeatLength = _NoteBox.frame.size.width;
    printf("this is onebeatLength %f \n", _oneBeatLength);
    _index = 0;
    _idx = 1;
    _buffer  = 3;
    _NoteInput = [[NSMutableArray alloc]init];
    _NoteOutput = [[NSMutableArray alloc]init];
    _secPerBeat = 60.0/_tempo;
    _speed = _oneBeatLength/_secPerBeat;
    _octaveValue = 12;
    _notesPerScreen = 25;
    _noteHeight = self.frame.size.height/ _notesPerScreen;
    _octaveLength = _octaveValue * _noteHeight;
    _scoreBarXpos = self.frame.size.width/3;
    printf("\n %f scorebarXpos",_scoreBarXpos);
    
    // Draw background (Only on devices not simulator)
    SKSpriteNode *bg= [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
    bg.anchorPoint = CGPointMake(0,0);
    bg.position = CGPointMake(0,0);
    bg.xScale = _scaleX;
    bg.yScale = _scaleY;
    [self addChild:bg];
    
    //Draw ScoreBar
    SKSpriteNode *ScoreBar = [SKSpriteNode spriteNodeWithImageNamed:@"ScoreLine.png"];
    ScoreBar.zPosition = 1;
    ScoreBar.name = @"BAR";
    ScoreBar.anchorPoint = CGPointMake(0, 0);
    ScoreBar.position = CGPointMake(_scoreBarXpos, 0);
    ScoreBar.xScale = _scaleX;
    ScoreBar.yScale = 1.07 * _scaleY;
    [self addChild:ScoreBar];
    
    //Draw Piano Roll
    SKSpriteNode *pianoRoll = [SKSpriteNode spriteNodeWithImageNamed:pianoName];
    pianoRoll.xScale = _scaleX;
    pianoRoll.yScale = _scaleY;
    pianoRoll.zPosition = 1;
    pianoRoll.anchorPoint = CGPointMake(0, 0);
    pianoRoll.position = CGPointMake(ScoreBar.frame.origin.x-pianoRoll.self.frame.size.width, 0);
    pianoRoll.name = @"PIANO";
    [self addChild:pianoRoll];
    
    //Draw pause Button
    _pause = [SKSpriteNode spriteNodeWithImageNamed:@"Pause.png"];
    _pause.zPosition = 3;
    _pause.anchorPoint = CGPointMake(0, 0);
    _pause.position = CGPointMake(_scaleX*(568-18)*2,3*_scaleY*2);
    _pause.xScale = 0.5*_scaleX;
    _pause.yScale = 0.5*_scaleY;
    [self addChild:_pause];
    
    //Make pause overlay
    _PauseOverlay = [SKSpriteNode spriteNodeWithImageNamed:@"PauseOverlay.png"];
    _PauseOverlay.anchorPoint = CGPointMake(0, 0);
    _PauseOverlay.position = CGPointMake(0, 0);
    _PauseOverlay.zPosition = 5;
    _PauseOverlay.xScale = _scaleX;
    _PauseOverlay.yScale = _scaleY;
    
    //Make saveRecord overlay
    _SaveRecordingOverlay = [SKSpriteNode spriteNodeWithImageNamed:@"saveRecording.png"];
    _SaveRecordingOverlay.anchorPoint = CGPointMake(0, 0);
    _SaveRecordingOverlay.position = CGPointMake(0, 0);
    _SaveRecordingOverlay.zPosition = 10;
    _SaveRecordingOverlay.xScale = _scaleX;
    _SaveRecordingOverlay.yScale = _scaleY;
    
    //Make gameover overlay
    _songOver = [SKSpriteNode spriteNodeWithImageNamed:@"gameover.png"];
    _songOver.anchorPoint = CGPointMake(0, 0);
    _songOver.position = CGPointMake(0, 0);
    _songOver.zPosition = 10;
    _songOver.xScale = _scaleX;
    _songOver.yScale = _scaleY;
    
    //Make scoring
    _scoreValue = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Bold"];
    _scoreValue.text = [NSString stringWithFormat:@"Current Score: 0.00000"];
    _scoreValue.fontSize = 10*_scaleY*2;
    _scoreValue.fontColor = [UIColor blackColor];
    _scoreValue.position = CGPointMake(_framesize.width/2 , _scaleY*(320-10)*2);
    _scoreValue.zPosition = 11;
    [self addChild:_scoreValue];
}

//Method to setup musicPlayer
-(void)playMusic:(NSString*)SongName
withShortStartDelay:(NSTimeInterval)shortStartDelay
{
    NSError *err;
    NSString *path  = [[NSBundle mainBundle] pathForResource:SongName ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    if (err)
        NSLog (@"Cannot Load audio");
    else
    {
        NSLog(@"succeed!");
        _songPlayStartTime = _currTime + shortStartDelay;
        [_player playAtTime:_currTime + shortStartDelay];
    }
}

-(void)playMusicCustom:(NSString*)SongName
   withShortStartDelay:(NSTimeInterval)shortStartDelay
{
    NSError *err;
    NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* docsDir = [dirPaths[0] stringByAppendingString:@"/"];
    NSString* filePath = [[docsDir stringByAppendingString:SongName] stringByAppendingString:@".mp3"];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    if (err)
        NSLog (@"Cannot Load audio");
    else
    {
        NSLog(@"succeed!");
        _songPlayStartTime = _currTime + shortStartDelay;
        [_player playAtTime:_currTime + shortStartDelay];
    }
}

//Method to initialize Arrow
-(void)MakeArrow
{
    SKNode *Piano = [self childNodeWithName:@"PIANO"];
    _moveBy = -1.0;
    _paths = [[NSMutableArray alloc]init];
    _Arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow2.png"];
    _offset = 13 * _scaleX*2;
    _starting = Piano.frame.origin.x - _offset;
    _Arrow.position = CGPointMake(_starting, 200*_scaleY*2);
    _Arrow.xScale = 0.3*_scaleX*2;
    _Arrow.yScale = 0.3*_scaleY*2;
    _Arrow.zPosition = 2;
    _Arrow.name = @"ARROW";
    [self addChild:_Arrow];
    
    //Setting up tail path
    CGMutablePathRef _pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(_pathToDraw, NULL, _starting*_scaleX, 200*_scaleY*2);
    _lineNode = [SKShapeNode node];
    _lineNode.path = _pathToDraw;
    _lineNode.strokeColor = [SKColor blackColor];
    _lineNode.lineWidth = 0.5*_scaleX*2;
    _lineNode.zPosition = 2;
    [self addChild:_lineNode];
    
    CGPathRelease(_pathToDraw);
}

//Method to determine what happens if touch begins
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location =[ [touches anyObject] locationInNode:self];
    CGRect resume = CGRectMake(173*2*_scaleX, (320-184)*2*_scaleY, 90*2*_scaleX, 28*2*_scaleY);
    CGRect exit  = CGRectMake(311*2*_scaleX, (320-184)*2*_scaleY, 90*2*_scaleX, 28*2*_scaleY);
    CGRect pauseButton = CGRectMake((568-15-3)*2*_scaleX, 3*2, 15*2*_scaleX, 30*2*_scaleY);
    
    if (_songIsOver == 0)
    {
        if (CGRectContainsPoint(pauseButton, location))
        {
            if (_statusGo == 1 && (CACurrentMediaTime() > _songPlayStartTime))
            {
                [self addChild:_PauseOverlay];
                _isPausedScene= 1;
                _pauseTime = CACurrentMediaTime();
            }
        }
        else if (self.view.isPaused)
        {
            if (CGRectContainsPoint(resume, location) && ((CACurrentMediaTime() - _pauseTime)>1.3f))
            {
                [_PauseOverlay removeFromParent];
                [_player play];
                self.view.paused = NO;
                _isPausedScene = 0;
            }
            else if (CGRectContainsPoint(exit, location)&& ((CACurrentMediaTime() - _pauseTime)>1.3f))
            {
                self.view.paused = NO;
                _isPausedScene = 0;

                SKScene *songChoose = [SongChooseMenu sceneWithSize:self.size];
                songChoose.scaleMode = SKSceneScaleModeAspectFill;
                
                [self.view presentScene:songChoose transition:[SKTransition fadeWithDuration:1.5]];
                
                [_audioController stopIOUnit];
                _audioController = NULL;
                [_audioController removeTmpFiles];
            }
        }
    }
    else if (_songIsOver == 1)
    {
        CGRect SaveRecording = CGRectMake(173*2*_scaleX, (320-184)*2*_scaleY, 91*2*_scaleX, 26*2*_scaleY);
        CGRect DontSaveRecording = CGRectMake(313*2*_scaleX, (320-184)*2*_scaleY, 91*2*_scaleX, 26*2*_scaleY);
        
        if (CGRectContainsPoint(SaveRecording, location))
        {
            [_audioController saveRecording:_songName PlayerName:[[NSUserDefaults standardUserDefaults] objectForKey:@"myname"]];
            [_SaveRecordingOverlay removeFromParent];
            [self addChild:_songOver];
            _songIsOver = 2;
        }
        else if (CGRectContainsPoint(DontSaveRecording, location))
        {
            [_audioController removeTmpFiles];
            [_SaveRecordingOverlay removeFromParent];
            [self addChild:_songOver];
            _finishTime = CACurrentMediaTime();
            _songIsOver = 2;
        }
    }
    else if (_songIsOver == 3)
    {
        CGRect replay = CGRectMake(173*2*_scaleX, (320-184)*2*_scaleY, 91*2*_scaleX, 26*2*_scaleY);
        CGRect exitSong = CGRectMake(313*2*_scaleX, (320-184)*2*_scaleY, 91*2*_scaleX, 26*2*_scaleY);
        
        if (CGRectContainsPoint(replay, location) && ((CACurrentMediaTime() - _finishTime)>2.5f))
        {
            SKScene *replaySong = [[SongScene alloc]initWithSize:self.size withSongName:_songName withTempo:_tempo withDelay:_delay withInput:_StringInput withC3YPos:_C3Ypos withPianoName:_pianoName withLyrics:_LyricsName withLyricsDuration:_lyricsDuration];
            replaySong.scaleMode = SKSceneScaleModeAspectFill;
            
            [_audioController stopIOUnit];
            _audioController = NULL;
            [_audioController removeTmpFiles];
            
            [self.view presentScene:replaySong transition:[SKTransition crossFadeWithDuration:1.5]];
        }
        else if (CGRectContainsPoint(exitSong, location)&& ((CACurrentMediaTime() - _finishTime)>2.5f))
        {

            SKScene *songChoose = [SongChooseMenu sceneWithSize:self.size];
            songChoose.scaleMode = SKSceneScaleModeAspectFill;
            
            [self.view presentScene:songChoose transition:[SKTransition fadeWithDuration:1.5]];

            [_audioController stopIOUnit];
            _audioController = NULL;
            [_audioController removeTmpFiles];
        }
    }
}

//Calculating note distance based on C3 position
-(int)getNoteDistance:(NSString*)noteName
{
    int answer = 0;
    
    NSString* oct = [noteName substringFromIndex:noteName.length-1];
    NSString* newNoteName = [noteName substringToIndex:noteName.length-1];
    int difference = ((int)(oct.integerValue) - 3)*_octaveValue;
    
    if ([newNoteName compare:@"C"]==0)
    {
        answer = 0 + difference;
        return answer;
    }
    else if([newNoteName compare:@"C#"]==0 || [newNoteName compare:@"Db"] == 0)
    {
        answer = 1 + difference;
        return answer;
    }
    else if([newNoteName compare:@"D"]==0)
    {
        answer = 2 + difference;
        return answer;
    }
    else if([newNoteName compare:@"D#"]==0 || [newNoteName compare:@"Eb"] == 0)
    {
        answer = 3 + difference;
        return answer;
    }
    else if([newNoteName compare:@"E"]==0)
    {
        answer = 4 + difference;
        return answer;
    }
    else if([newNoteName compare:@"F"]==0)
    {
        answer = 5 + difference;
        return answer;
    }
    else if([newNoteName compare:@"F#"]==0 || [newNoteName compare:@"Gb"]==0)
    {
        answer = 6 + difference;
        return answer;
    }
    else if([newNoteName compare:@"G"] ==0)
    {
        answer = 7 + difference;
        return answer;
    }
    else if([newNoteName compare:@"G#"]==0 || [newNoteName compare:@"Ab"]==0)
    {
        answer = 8 + difference;
        return answer;
    }
    else if([newNoteName compare:@"A"]==0)
    {
        answer = 9 + difference;
        return answer;
    }
    else if([newNoteName compare:@"A#"]==0 || [newNoteName compare:@"Bb"]==0)
    {
        answer = 10 + difference;
        return answer;
    }
    else if([newNoteName compare:@"B"] == 0)
    {
        answer = 11 + difference;
        return answer;
    }
    
    return answer;
}

//method called by update to add and render note to the screen whenever the previous note has entirely left the screen
-(void)loadNote
{
    if (_index < _NoteInput.count)
    {
        NoteClass *toGo = [_NoteInput objectAtIndex:_index];
        SKSpriteNode *toGoNode = [toGo getNoteShape];
        
        float duration = (_framesize.width + [toGo getLength])/_speed;
        
        CGPoint point = CGPointMake(toGoNode.frame.origin.x - _buffer*2*_scaleX, toGoNode.frame.origin.y);
        toGoNode.position = point;
        
        SKAction *goLeft = [SKAction moveToX:(0 - [toGo getLength]) duration:duration];
        [toGoNode runAction:goLeft];
        _CurrentNode = toGo;
        [_NoteOutput addObject:toGo];
        
        [self addChild:toGoNode];
        _index++;
    }
}

//Method called by Update to remove notes from the screen as soon as they have finished travelling the whole width of screen
-(void)unloadNote
{
    NoteClass *toRemoveNode = [_NoteOutput objectAtIndex:0];
    SKSpriteNode *RM = [toRemoveNode getNoteShape];
    [RM removeFromParent];
    [_NoteOutput removeObjectAtIndex:0];
    _FrontNode = [_NoteOutput objectAtIndex:0];
    
    if (_NoteOutput.count == 1)
    {
        NSLog(@"Song over");
        [self addChild:_SaveRecordingOverlay];
        [_scoreValue removeFromParent];
        _songIsOver = 1;
    }
}

//Method that is called by Update to check clash between note and scoreBar
-(void)clashCheck
{
    NSString *pitchHitNode = [_HittingNode getPitch];
    SKSpriteNode *clash = [_HittingNode getNoteShape];
    SKNode *bar = [self childNodeWithName:@"BAR"];
    float barMax = CGRectGetMaxX(bar.frame);
    float noteMin = CGRectGetMinX(clash.frame);
    float barMin = CGRectGetMinX(bar.frame);
    float noteMax = CGRectGetMaxX(clash.frame);
    
    if (barMin > noteMin && noteMax > barMin && [pitchHitNode compare:@"rest"] != 0)
    {
        if (_firstColision == 0)
        {
            _firstColision = 1;
            double time = CACurrentMediaTime();
            double timeDelay = time - _currTime;
            printf("\n first collision time %f", timeDelay);
        }
        
        int a = [self getNoteDistance:pitchHitNode];
        int b = [self getNoteDistance:_pitch];
        if (a == b)
            _currentScore++;
       // printf("\n current pitch is : %d, estimated pitch is: %d", a,b);

        _totalCurrentscore ++;
        _totalscore++;
    }
    else if ((noteMax < barMin && _idx < _NoteInput.count) || ([pitchHitNode compare:@"rest"] == 0 && _idx < _NoteInput.count))
    {
        double scoreCompare = (double)_currentScore / (double)_totalCurrentscore;
        if (scoreCompare >= 0.2)
            _myScore = _myScore + _totalCurrentscore;
        else
            _myScore = _myScore + _currentScore;
        
        _currentScore = 0;
        _totalCurrentscore = 0;
        _HittingNode = [_NoteInput objectAtIndex:_idx];
        _idx++;
    }

    NSString *pitchHitNodeSpark = [_SparkledNode getPitch];
    SKSpriteNode *spark = [_SparkledNode getNoteShape];
    float noteMinSpark = CGRectGetMinX(spark.frame);
    
    if(barMin < noteMinSpark && noteMinSpark < barMax && _SparkleIdx< _NoteInput.count && [pitchHitNodeSpark compare:@"rest"] != 0)
    {
        
        SKEmitterNode *explosionTwo = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"explode" ofType:@"sks"]];
        [explosionTwo setNumParticlesToEmit:40];
        explosionTwo.position = CGPointMake(_scoreBarXpos, [_SparkledNode getyLocation] + 5*_scaleY*2);
        explosionTwo.zPosition = 5;
        explosionTwo.xScale = 0.5*_scaleX*2;
        explosionTwo.yScale = 0.3*_scaleY*2;
        [self addChild:explosionTwo];
        _SparkledNode = [_NoteInput objectAtIndex:_SparkleIdx];
        if (_SparkleIdx < _NoteInput.count-1)
            _SparkleIdx++;
    }
    else if ([pitchHitNodeSpark compare:@"rest"] == 0 && _SparkleIdx < _NoteInput.count)
    {
        _SparkledNode = [_NoteInput objectAtIndex:_SparkleIdx];
        if (_SparkleIdx < _NoteInput.count-1)
            _SparkleIdx++;
    }
}

//Method called by Update to move the tail of the arrow
-(void)ArrowMove
{
    CGPoint newPt = CGPointMake(_Arrow.frame.origin.x + 5*_scaleX*2, _Arrow.frame.origin.y + (_Arrow.frame.size.height/2));
    [_paths addObject:[NSValue valueWithCGPoint:newPt]];
    
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    NSValue *startingValue = [_paths objectAtIndex:0];
    CGPoint st = startingValue.CGPointValue;
    CGPathMoveToPoint(pathToDraw, NULL, st.x, st.y);

    if (st.x < 1)
    {
        [_paths removeObjectAtIndex:0];
        startingValue = [_paths objectAtIndex:0];
        st = startingValue.CGPointValue;
        CGPathMoveToPoint(pathToDraw, NULL, st.x, st.y);
    }

    for (int i = 0; i<[_paths count]; i++)
    {
        NSValue *temp = [_paths objectAtIndex:i];
        CGPoint tempPt = temp.CGPointValue;
        tempPt.x = tempPt.x + _moveBy*_scaleX*2;
        [_paths replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:tempPt]];

        CGPathAddLineToPoint(pathToDraw, NULL, tempPt.x, tempPt.y);
    }

    _lineNode.path = pathToDraw;
    CGPathRelease(pathToDraw);
}

//Method called by Update to check pitch of the input Soundwave
-(void)pitchUpdate
{
    NSString *_pitchNew = [_audioController CurrentPitchAboveNoise];
   // NSLog(_pitchNew);
    if ([_pitchNew compare:@"nil"]!=0)
    {
        if (_voiceState == 1)
            [self RemoveVoiceWarning];
        _pitch = _pitchNew;
    }
    else
    {
        if(_voiceState == 0)
            [self AddVoiceWarning];
    }
    
    int distance = [self getNoteDistance:_pitch];
    float yPositionforArrow  =  _C3Ypos*_scaleY + 13 * distance * _scaleY *2+ 1 *_scaleY*2;
    
    if (yPositionforArrow <0)
        yPositionforArrow = 0 + 3*_scaleY*2;
    else if(yPositionforArrow > _framesize.height)
        yPositionforArrow = _framesize.height - 3*_scaleY*2;
    
    if ([_previousPitch compare:_pitch] != 0)
    {
        CGPoint position = CGPointMake(_starting, yPositionforArrow + 5*_scaleY*2);
        SKAction *moveToLocation = [SKAction moveTo:position duration:0.2];
        [_Arrow runAction:moveToLocation];
        _previousPitch = _pitch;
    }

}

-(void)update:(CFTimeInterval)currentTime
{
    //Check if self is paused
    if (self.view.isPaused == YES)
    {
        //Do not update anything if song is paused
    }
    else if(_songIsOver == 1)
    {
        //Do note update anything
    }
    else if (_songIsOver == 2 )
    {
        double scoreEarned = (double)_myScore;
        double totalAllScore = (double)_totalscore;
        
        double finalScore = scoreEarned/totalAllScore * 100;
        
        printf("\n This is actualtotalscore : %f", totalAllScore);
        [_scoreValue removeFromParent];
        _scoreValue = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Bold"];
        _scoreValue.fontSize = 20*_scaleY*2;
        _scoreValue.fontColor = [UIColor blackColor];
        _scoreValue.text = [NSString stringWithFormat:@"%f", finalScore];
        _scoreValue.position = CGPointMake(338*_scaleX*2, (320-133)*_scaleY*2);
        _scoreValue.zPosition = 11;
        [self addChild:_scoreValue];

        NSUserDefaults* userDefs = [NSUserDefaults standardUserDefaults];

        NSInteger songType = [userDefs integerForKey:@"songType"];
        NSString* HSstringToEnter = @"highScore";
        NSString* songTypeString = [NSString stringWithFormat:@"%d", (int)songType];
        HSstringToEnter = [HSstringToEnter stringByAppendingString:songTypeString];
        double HS = [userDefs doubleForKey:HSstringToEnter];
        
        if (finalScore > HS)
            [userDefs setDouble:finalScore forKey:HSstringToEnter];
        
        NSString* fileName = [userDefs objectForKey:@"myname"];
        fileName = [fileName stringByAppendingString:@"'s score"];
        fileName = [fileName stringByAppendingString:@".txt"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
            [[NSData data] writeToFile:path atomically:YES];
        
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
        [handle truncateFileAtOffset:[handle seekToEndOfFile]];
        
        NSString *tempString = @"Score at date ";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd_HHmm"];
        NSString *strNow = [dateFormatter stringFromDate:[NSDate date]];
        
        strNow = [tempString stringByAppendingString:strNow];
        NSString *songTypeTemp = @" and song number: ";
        strNow = [strNow stringByAppendingString:songTypeTemp];
        strNow = [strNow stringByAppendingString:songTypeString];
        
        songTypeTemp = @" ";
        strNow = [strNow stringByAppendingString:songTypeTemp];
        
        tempString = @" is: ";
        strNow = [strNow stringByAppendingString: tempString];
        
        NSString* myScoreToWriteToHistory = [NSString stringWithFormat:@"%f", finalScore];
        
        myScoreToWriteToHistory = [strNow stringByAppendingString:myScoreToWriteToHistory];
        myScoreToWriteToHistory = [myScoreToWriteToHistory stringByAppendingString:@"\n"];
        
        [handle writeData:[myScoreToWriteToHistory dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
        NSLog(@"Score saved.");
        
        _songIsOver = 3;
    }
    else if (_songIsOver == 3)
    {
        //Do nothing
    }
    else
    {
        if (_isPausedScene == 1)
        {
            [_player pause];
            self.view.paused = YES;
        }
        else
        {
            if (currentTime - _currTime > _loading)
            {
                if (_statusGo == 0)
                {
                    _statusGo = 1;
                    [self loadNote];
                    [self ArrowMove];
                }
                [self ArrowMove];
                
                SKSpriteNode *currNode = [_CurrentNode getNoteShape];
                float location = currNode.frame.origin.x;
                float nextNode = _framesize.width - [_CurrentNode getLength];
                if (location < nextNode && _index < _NoteInput.count)
                    [self loadNote];
                
                SKSpriteNode *frntNode = [_FrontNode getNoteShape];
                float myLocation = frntNode.frame.origin.x + (frntNode.frame.size.width - 10)*_scaleX;
                if (myLocation <= 5*_scaleX && _NoteOutput.count > 1)
                    [self unloadNote];
                
                if (_doPitch % 5 == 0)
                {
                    [self pitchUpdate];
                    _doPitch = 1;
                }
                else
                    _doPitch ++;
                
                [self clashCheck];
                
                if (_scoreUpdate %20 == 0)
                {
                    [_scoreValue removeFromParent];
                    double currentScore = (double)_myScore / (double)_predictedTotalScore * 100;
                    _scoreValue = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Bold"];
                    _scoreValue.text = [NSString stringWithFormat:@"Current Score: %f", currentScore];
                    _scoreValue.fontSize = 10*_scaleY*2;
                    _scoreValue.fontColor = [UIColor blackColor];
                    _scoreValue.position = CGPointMake(_framesize.width/2 , _scaleY*(320-10)*2);
                    _scoreValue.zPosition = 11;
                    [self addChild:_scoreValue];
                    _scoreUpdate = 1;
                }
                else
                    _scoreUpdate = _scoreUpdate + 1;
            }
        }
    }
}

-(void) setupLyrics:(NSString*)filename withDuration:(float)songDuration
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    NSMutableArray *listArray = [NSMutableArray arrayWithArray:[fileContents componentsSeparatedByString:@"\n"]];
    
    _Text = [SKNode node];
    _Text.zPosition = 2;
    
    _lyricsoverlay= [SKSpriteNode spriteNodeWithImageNamed:@"lyricsOverlay"];
    _lyricsoverlay.anchorPoint = CGPointMake(0, 0);
    _lyricsoverlay.position = CGPointMake(564*_scaleX*2, 0);
    _lyricsoverlay.zPosition = 2;
    _lyricsoverlay.hidden = YES;
    _lyricsoverlay.xScale = _scaleX;
    _lyricsoverlay.yScale = _scaleY;
    [self addChild:_lyricsoverlay];
    
    int count = 0;
    int distance = 100*_scaleY*2;
    if (listArray.count > 26)
    {
        int leftover = (int)listArray.count - 28;
        distance = leftover * 12*_scaleY*2;
    }
    
    for (NSString* string in listArray)
    {
        SKLabelNode *a = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Bold"];
        a.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        a.fontSize = 10*_scaleX*2;
        a.fontColor = [SKColor blackColor];
        a.position = CGPointMake(a.position.x, a.position.y - (11*_scaleY * count*2));
        count++;
        a.text = string;
        [_Text addChild:a];
    }
    
    _Text.position = CGPointMake(570*_scaleX*2, _scaleY*295.0*2);
    SKAction* moveUp = [SKAction moveByX:0 y:distance duration:songDuration];
    [_Text runAction:moveUp];
    
    _Text.hidden = YES;
    [self addChild:_Text];
    _TextState = 0;
}

-(void) didMoveToView: (SKView *) view
{
    _swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector( handleSwipeRight:)];
    [_swipeRightGesture setDirection: UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer: _swipeRightGesture ];
    
    _swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeft:)];
    [_swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [view addGestureRecognizer:_swipeLeftGesture];
    
}

- ( void ) willMoveFromView: (SKView *) view
{
    [view removeGestureRecognizer: _swipeRightGesture ];
    [view removeGestureRecognizer:_swipeLeftGesture];
    NSLog(@"Removing gesRec");
}


-(void) handleSwipeLeft: ( UISwipeGestureRecognizer*) recognizer
{
    if (_TextState == 0)
    {
        SKAction *goLeft = [SKAction moveByX:-138*_scaleX*2 y:0 duration:0.5f];
        [_lyricsoverlay runAction:goLeft];
        [_Text runAction:goLeft];
        _lyricsoverlay.hidden = NO;
        _Text.hidden = NO;
        _TextState = 1;
    }
}

-(void) handleSwipeRight:( UISwipeGestureRecognizer *) recognizer
{
    if (_TextState == 1)
    {
        SKAction *goRight = [SKAction moveByX:140*_scaleX*2 y:0 duration:0.5f];
        [_lyricsoverlay runAction:goRight];
        [_Text runAction:goRight];
        _TextState = 0;
    }
}

-(void) RemoveVoiceWarning
{
    _voiceState = 0;
    [_VoiceWarning removeFromParent];
}

-(void) AddVoiceWarning
{
    NSString* string = @"Voice undetected, please sing louder.";
    _VoiceWarning = [SKLabelNode labelNodeWithFontNamed:@"IowanOldStyle-Bold"];
    _VoiceWarning.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _VoiceWarning.fontSize = 10*_scaleX*2;
    _VoiceWarning.fontColor = [SKColor blackColor];
    _VoiceWarning.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-5);
    _VoiceWarning.text = string;
    _VoiceWarning.zPosition = 25;
    [self addChild:_VoiceWarning];
    _voiceState = 1;
}
@end
