//
//  ViewController.m
//  SwiperTest
//
//  Created by Chase Bradbury on 7/23/14.
//  Copyright (c) 2014 Redwood Studios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog([defaults boolForKey:@"initialized"] ? @"Defaults initialized" : @"Defaults NOT initialized" );
    NSLog(@"Highscore: %d", [defaults integerForKey:@"Highscore"]);
    
    if (![defaults boolForKey:@"initialized"])
    {
        [defaults setBool:YES forKey:@"initialized"];
        
        [defaults setInteger:0 forKey:@"Highscore"];
        
        [defaults synchronize];
    }
    
    highscore = [defaults integerForKey:@"Highscore"];
    highscoreLabel.text = [NSString stringWithFormat:@"Highscore: %i", highscore];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self restartGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)restartGame
{
    direction = up;
    score = -1;
    timeMax = 3;
    time = timeMax;
    interval = 1.5f;
    
    repMax = 3;
    
    // Change this
    //highscore = 0;
    
    startButton.hidden = NO;
    menuButton.hidden = NO;
    scoreLabel.hidden = YES;
    genericLabel.hidden = YES;
}

- (IBAction)startGame
{
    startButton.hidden = YES;
    menuButton.hidden = YES;
    swipeControl.enabled = YES;
    arrowImage.hidden = NO;
    timeLabel.hidden = NO;
    scoreLabel.hidden = NO;
    highscoreLabel.hidden = YES;
    
    [self swipeAction];
    
    timeLabel.text = [NSString stringWithFormat:@"%i", time];
    
    [timer invalidate];
    timer = nil;
    
    [self setTimerFor:interval Repeats:repMax];
}

- (void)endGame
{
    swipeControl.enabled = NO;
    arrowImage.hidden = YES;
    timeLabel.hidden = YES;
    highscoreLabel.hidden = NO;
    genericLabel.hidden = NO;
    
    genericLabel.text = @"Game over!";
    
    [timer invalidate];
    timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(changeHighscore)
                                           userInfo:nil
                                            repeats:NO];
}

- (void)changeHighscore
{
    if (score > highscore)
    {
        
        genericLabel.text = @"New highscore!";
        highscore = score;
        highscoreLabel.text = [NSString stringWithFormat:@"Highscore: %i", highscore];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:highscore forKey:@"Highscore"];
        [defaults synchronize];
        
        [timer invalidate];
        timer = nil;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(restartGame)
                                               userInfo:nil
                                                repeats:NO];
    }
    else
    {
        [self restartGame];
    }
    
}

- (IBAction)swipeAction
{
    if (interval > 1.0)
    {
        interval -= 0.02;
    } else if (interval > 0.5)
    {
        interval -= 0.01;
    } else if (score % 50 == 0 && interval > 0.3)
    {
        interval -= 0.01;
    }
    
    time = timeMax;
    timeLabel.text = [NSString stringWithFormat:@"%i", time];
    
    scoreLabel.text = [NSString stringWithFormat:@"Score: %i", ++score];
    
    [timer invalidate];
    timer = nil;
    
    [self setTimerFor:interval Repeats:repMax];
    
    NSLog(@"Swiped.");
    
    // Get a random direction
    direction = arc4random() % 4;
    
    if (direction == up)
    {
        NSLog(@"Swipe up!");
        [swipeControl setDirection:UISwipeGestureRecognizerDirectionUp];
        arrowImage.image = [UIImage imageNamed:@"arrowUp"];
    }
    else if (direction == down)
    {
        NSLog(@"Swipe down!");
        [swipeControl setDirection:UISwipeGestureRecognizerDirectionDown];
        arrowImage.image = [UIImage imageNamed:@"arrowDown"];
    }
    else if (direction == left)
    {
        NSLog(@"Swipe left!");
        [swipeControl setDirection:UISwipeGestureRecognizerDirectionLeft];
        arrowImage.image = [UIImage imageNamed:@"arrowLeft"];
    }
    else
    {
        NSLog(@"Swipe right!");
        [swipeControl setDirection:UISwipeGestureRecognizerDirectionRight];
        arrowImage.image = [UIImage imageNamed:@"arrowRight"];
    }
    
}

- (void)countDown
{
    timeLabel.text = [NSString stringWithFormat:@"%i", --time];
    
    if (time < 0)
    {
        [self endGame];
    }
}

- (void)setTimerFor:(float)seconds Repeats:(NSInteger)reps
{
    timer = [NSTimer scheduledTimerWithTimeInterval:seconds/reps
                                             target:self
                                           selector:@selector(countDown)
                                           userInfo:nil
                                            repeats:YES];
}

- (IBAction)toggleMenu
{
    if (menuOpen)
    {
        menuOpen = NO;
        [menuButton setTitle:@"Menu" forState:UIControlStateNormal];
        resetButton.hidden = YES;
        highscoreLabel.hidden = NO;
        [self restartGame];
    } else
    {
        menuOpen = YES;
        resetButton.hidden = NO;
        [menuButton setTitle:@"Back" forState:UIControlStateNormal];
        startButton.hidden = YES;
        highscoreLabel.hidden = YES;
    }
    
}

- (IBAction)resetHighscore
{
    highscore = 0;
    
    highscoreLabel.text = [NSString stringWithFormat:@"Highscore: %i", highscore];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:highscore forKey:@"Highscore"];
    [defaults synchronize];
}

@end
