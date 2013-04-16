//
//  LegalViewController.m
//  MadrigalChallenge
//
//  Created by Susan Surapruik on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LegalViewController.h"

@implementation LegalViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[self initializeView];
	
	_babyAnimalView = [[BabyAnimalView alloc] initWithFrame:CGRectZero];
	_babyAnimalView._imageFileName = @"screen_legal";
	_babyAnimalView.frame = self.view.bounds; //FS this is scaling up the image to the iphone 5 aspect ratio
	[self.view addSubview:_babyAnimalView];
	
	_moreGamesButton = [self createButtonWithImage:@"moregames" x:75 y:127]; //FS this needs to be percentage for iphone 5
	[_moreGamesButton addTarget:self action:@selector(moreGames:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_moreGamesButton];
	
	[self initializeViewAnimation];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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


- (void)dealloc {
	if (_noWebConnection) {
		[_noWebConnection release];
	}
    [super dealloc];
}

// A tap starts game play
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	[self fadeView];
}

- (void) viewVisible {
	[super viewVisible];
	// Start the game timer
	_startTime = CFAbsoluteTimeGetCurrent();
	_timer = [NSTimer scheduledTimerWithTimeInterval:(kLegalTimeOut) target:self selector:@selector(fadeView) userInfo:nil repeats:NO];
}

- (void) removeView {
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] changeState:kGameState_Title];
}

- (void) pause:(BOOL)flag {
	if (flag) {
		if (_timer) {
			[_timer invalidate];
			_timer = nil;
			_pauseTime = CFAbsoluteTimeGetCurrent() - _startTime;
			_timerPaused = YES;
		}
	} else if (_timerPaused) {
		_startTime = CFAbsoluteTimeGetCurrent();
		_timer = [NSTimer scheduledTimerWithTimeInterval:(_pauseTime) target:self selector:@selector(fadeView) userInfo:nil repeats:NO];
	}
}

#pragma mark -
#pragma mark More Games

- (BOOL) connectedToNetwork:(NSString*)urlString {
	return ([NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]]!=NULL)?YES:NO;
}

- (void) moreGames:(id)sender {
	[_timer invalidate];
	_timer = nil;
	
	if ([self connectedToNetwork:kURLRequest]) {
		NSURL *url = [NSURL URLWithString:kURLRequest];
		[[UIApplication sharedApplication] openURL:url];
	} else {
		_noWebConnection = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uhoh_popup.png"]];
		_noWebConnection.center = CGPointMake(97, 240);
		[self.view addSubview:_noWebConnection];
		
		[_moreGamesButton removeFromSuperview];
		
		// Start the game timer
		_startTime = CFAbsoluteTimeGetCurrent();
		_timer = [NSTimer scheduledTimerWithTimeInterval:(kLegalTimeOut) target:self selector:@selector(fadeView) userInfo:nil repeats:NO];
	}
}

@end