//
//  TitleViewController.m
//  MadrigalChallenge
//
//  Created by Susan Surapruik on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TitleViewController.h"
#import "BabyAnimalsAppDelegate.h"
#import "BabyAnimalEAGLView.h"

@implementation TitleViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[self initializeView];

	_babyAnimalView = [[BabyAnimalView alloc] initWithFrame:CGRectZero];
	_babyAnimalView._imageFileName = @"screen_splash";
	_babyAnimalView.frame = self.view.bounds;
	[self.view addSubview:_babyAnimalView];

	
	_babyAnimalEAGLView0 = [[BabyAnimalEAGLView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:_babyAnimalEAGLView0];
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	_babyAnimalEAGLView0._imageFileName = @"screen_splash_01";
	
	self.view.userInteractionEnabled = NO;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



- (void) initializeViewAnimation {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kViewFadeTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(viewVisible)];
	self.view.alpha = 1.0;
	[UIView commitAnimations];
}

- (void) viewVisible {
	self.view.userInteractionEnabled = YES;
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] playSound:kTitleAudio restart:YES];
	[self startAnimationTimer];
}


// A tap starts game play
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] stopSound:kTitleAudio];
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] fadeSoundOut:@"MUSIC_intro"];
	[self fadeView];
}

- (void) removeView {
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] changeState:kGameState_Game];
}

- (void) fadeView {
	self.view.userInteractionEnabled = NO;
	
	[self invalidateTimer];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeView)];
	self.view.alpha = 0.0;
	[UIView commitAnimations];
}

- (void) startAnimationTimer {
	_timer = nil;
	if (_currentAnimation == 1 && _animationStarted) {
		CGFloat iRandomTime = 5.0 + arc4random() % 5;
		_timer = [NSTimer scheduledTimerWithTimeInterval:iRandomTime target:self selector:@selector(updateAnimationImage) userInfo:nil repeats:NO];
	} else {
		_animationStarted = YES;
		_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / kRenderingFPS) target:self selector:@selector(updateAnimationImage) userInfo:nil repeats:NO];
	}
}

- (void) invalidateTimer {
	if (_timer) {
		[_timer invalidate];
		_timer = nil;
	}
}

- (void) updateAnimationImage {
	_currentAnimation++;
	
	if (_currentAnimation > [_levelData count] - 1) {
		_currentAnimation = 1;
	}
	
	NSString *imageName = [NSString stringWithFormat:@"screen_%@_0%d", _type, [[_levelData objectAtIndex:_currentAnimation] intValue]];
	
	_babyAnimalEAGLView0._imageFileName = imageName;
	[self startAnimationTimer];
}

- (void) setLevelData:(NSArray*)newLevelData {
	_levelData = [[NSArray alloc] initWithArray:newLevelData];
	
	_animationStarted = NO;
	_currentAnimation = 1;

	_type = [[NSString alloc] initWithString:[_levelData objectAtIndex:0]];
		
	[self initializeViewAnimation];
	
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] setSoundLoop:@"MUSIC_intro" loop:YES];
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] fadeSoundIn:@"MUSIC_intro"];
}

@end
