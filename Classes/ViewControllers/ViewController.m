//
//  ViewController.m
//  MadrigalChallenge
//
//  Created by Susan Surapruik on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

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
	
	[self createViewBackground];
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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
	[_backgroundImageName release];
    [super dealloc];
}

- (void) initializeView {
	UIView *view;
	CGRect mainRect;
	
	mainRect = [[UIScreen mainScreen] bounds];
	
	view = [[UIView alloc] initWithFrame:mainRect];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	self.view = view;
	[view release];
	
	self.view.alpha = 0.0;
	
	self.view.userInteractionEnabled = NO;
}

- (void) createViewBackground {
	if (_backgroundImageName != nil) {
		UIImage *image = [UIImage imageNamed:_backgroundImageName];
		UIImageView *_imageView = [[UIImageView alloc] initWithImage:image];
		
		_imageView.frame = CGRectMake((self.view.bounds.size.width - image.size.width) / 2, (self.view.bounds.size.height - image.size.height) / 2, image.size.width, image.size.height);
		[self.view addSubview:_imageView];
		
		[image release];
		[_imageView release];
	}
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
}

- (void) arrangeViewForLevel:(int)levelNum {	
}

- (void) fadeView {
	self.view.userInteractionEnabled = NO;
	
	[self invalidateTimer];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kViewFadeTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeView)];
	self.view.alpha = 0.0;
	[UIView commitAnimations];
}

- (void) removeView {
}

- (void) pause:(BOOL)flag {
}

- (void) setLevelData:(NSArray*)newLevelData {	
}

- (void) invalidateTimer {
	if (_timer) {
		[_timer invalidate];
		_timer = nil;
	}
}

- (UIButton*) createButtonWithImage:(NSString*)imageName x:(float)x y:(float)y {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	
	NSString *btnOff = [NSString stringWithString:imageName];
	btnOff = [btnOff stringByAppendingString:@"_up.png"];
	
	NSString *btnOver = [NSString stringWithString:imageName];
	btnOver = [btnOver stringByAppendingString:@"_down.png"];
	
	UIImage *btnImage = [UIImage imageNamed:btnOff];
	
	btn.backgroundColor = [UIColor clearColor];
	btn.frame = CGRectMake(x, y, btnImage.size.width, btnImage.size.height);
	
	[btn setBackgroundImage:btnImage forState:UIControlStateNormal];
	
	[btnImage release];
	
	btnImage = [UIImage imageNamed:btnOver];
	[btn setBackgroundImage:btnImage forState:UIControlStateHighlighted];
	[btn setBackgroundImage:btnImage forState:UIControlStateSelected];
	
	[btnImage release];
	
	return btn;
}

@end