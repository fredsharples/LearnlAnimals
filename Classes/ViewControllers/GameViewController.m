//
//  GameViewController.m
//  BabyAnimals
//
//  Created by Susan Surapruik on 9/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "BabyAnimalsAppDelegate.h"
#import "BabyAnimalEAGLView.h"
#import "BabyAnimalView.h"

@implementation GameViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	_screenBlinkMax = 4;
	
	self.view.userInteractionEnabled = NO;
	
	_paperImageView.image = [UIImage imageNamed:kImage_Paper];
	
	_soundIdentifier = @"";
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


- (void)dealloc {
	[self invalidateTimer];
	
	
	
	/* Removed because no swipe gestures anymore */
	//[_babyAnimalView0 release];
	//[_babyAnimalView1 release];
	
	
}

#pragma mark -
#pragma mark Animations

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
	[self playSoundIdentifier];
	[self startAnimationTimer];
}

- (void) crossFade {
	NSTimer *timer;
	
	[self invalidateTimer];
	
	self.view.userInteractionEnabled = NO;
	
	_paperImageView.alpha = 0.0;
	_babyAnimalEAGLView0.alpha = 1.0;
	_babyAnimalView.alpha = 1.0;
	
	/* Removed because no swipe gestures anymore */
	//_babyAnimalView0.center = CGPointMake(_paperImageView.center.x, _paperImageView.center.y - 480);
	//_babyAnimalView1.center = CGPointMake(_paperImageView.center.x, _paperImageView.center.y + 480);

	if (_currentImage < kSectionsPerLevel) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kViewFadeTime];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(viewFadedIn)];
		
		[self updateImage:_babyAnimalView forIndex:_currentImage forType:_type];
		_babyAnimalEAGLView0.alpha = 0.0;
		
		[UIView commitAnimations];
		
		timer = [NSTimer scheduledTimerWithTimeInterval:(kViewFadeTime/4.0) target:self selector:@selector(playScreenSound) userInfo:nil repeats:NO];
		
	} else {
		if (_levelNum + 1 < [_levels count]) {
			[self setLevelNum:_levelNum + 1];
		} else {
			[self setLevelNum:0];
		}
		
		_babyAnimalEAGLView0.alpha = 0.0;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kViewFadeTime];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(viewFadedIn)];
		
		[self updateImage:_babyAnimalView forIndex:_currentImage forType:_type];
		
		[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromLeft) forView:_babyAnimalView cache:YES];
		
		[UIView commitAnimations];
		
		timer = [NSTimer scheduledTimerWithTimeInterval:(kViewFadeTime/2.0) target:self selector:@selector(playLevelSound) userInfo:nil repeats:NO];
	}
}

/* Removed because no swipe gestures anymore */
/*
- (void) swipeAnimation {
	CGPoint eagleEndPoint, viewStartPoint, viewEndPoint;
	
	[self invalidateTimer];
	
	self.view.userInteractionEnabled = NO;
	
	_paperImageView.alpha = 0.0;
	_babyAnimalEAGLView0.alpha = 1.0;
	_babyAnimalView.alpha = 1.0;
	
	viewEndPoint = _paperImageView.center;
	
	if (_goBackwards) {
		viewStartPoint = CGPointMake(_paperImageView.center.x, _babyAnimalEAGLView0.center.y - 480);
		eagleEndPoint = CGPointMake(_paperImageView.center.x, viewEndPoint.y + 480);
		_babyAnimalView0.center = viewStartPoint;
	} else {
		viewStartPoint = CGPointMake(_paperImageView.center.x, _babyAnimalEAGLView0.center.y + 480);
		eagleEndPoint = CGPointMake(_paperImageView.center.x, viewEndPoint.y - 480);
		_babyAnimalView1.center = viewStartPoint;
	}
	
	if (_currentImage == kSectionsPerLevel) {
		if (_levelNum + 1 < [_levels count]) {
			[self setLevelNum:_levelNum + 1];
		} else {
			[self setLevelNum:0];
		}
	}
	
	[UIView beginAnimations:nil context:NULL];
	if (_babyAnimalEAGLView0.center.y == viewEndPoint.y) {
		[UIView setAnimationDuration:kViewFadeTime];
	} else {
		[UIView setAnimationDuration:kViewFadeTime/2.0];
	}
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(viewFadedIn)];
	
	if (_goBackwards) {
		_babyAnimalView0.center = viewEndPoint;
	} else {
		_babyAnimalView1.center = viewEndPoint;
	}
	_babyAnimalEAGLView0.center = eagleEndPoint;
	
	[UIView commitAnimations];
}
 */

- (void) viewFadedIn {
	//NSTimer *timer;
	
	[self updateImage:_babyAnimalView forIndex:_currentImage forType:_type];
	
	[self updateEAGLEImageView];
	_babyAnimalEAGLView0.alpha = 1.0;
	
	/* Removed because no swipe gestures anymore */
	//_babyAnimalEAGLView0.center = _babyAnimalView.center;
	//[self updateSideImages];
	
	[self playSoundIdentifier];
	
	if (_currentImage == 1) {
		[self startAnimationTimer];
	}
	self.view.userInteractionEnabled = YES;
	
	/* Removed because no swipe gestures anymore */
	//timer = [NSTimer scheduledTimerWithTimeInterval:(kViewFadeTime/4.0) target:self selector:@selector(allowInput) userInfo:nil repeats:NO];
}

/* Removed because no swipe gestures anymore */
/*
- (void) allowInput {
	self.view.userInteractionEnabled = YES;
	
	[self playSoundIdentifier];
	
	if (_currentImage == 1) {
		[self startAnimationTimer];
	}
}
 */

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

#pragma mark -
#pragma mark Update Image

- (NSString*) getImageFileName:(unsigned)imageIndex forType:(NSString*)type {
	NSString *imageName;
	if (imageIndex == 0 || imageIndex == kSectionsPerLevel) {
		imageName = [NSString stringWithFormat:@"screen_%@_drawing_01", type];
	} else if (imageIndex == 1) {
		imageName = [NSString stringWithFormat:@"screen_%@_word", type];
	} else if (imageIndex == 2) {
		imageName = [NSString stringWithFormat:@"screen_%@_image", type];
	}
	return imageName;
}

- (BOOL) getSpeckleVisible:(unsigned)imageIndex forType:(NSString*)type {
	if (imageIndex == 0 || imageIndex == kSectionsPerLevel || imageIndex == 1) {
		return YES;
	} else {
		return NO;
	}
}

- (void) updateImage:(BabyAnimalView*)babyAnimalView forIndex:(unsigned)imageIndex forType:(NSString*)type {
	NSString *imageName;
	if (imageIndex == 0 || imageIndex == kSectionsPerLevel) {
		babyAnimalView._showSpeckles = YES;
		imageName = [NSString stringWithFormat:@"screen_%@_drawing_01", type];
	} else if (imageIndex == 1) {
		babyAnimalView._showSpeckles = YES;
		imageName = [NSString stringWithFormat:@"screen_%@_word", type];
	} else if (imageIndex == 2) {
		babyAnimalView._showSpeckles = NO;
		imageName = [NSString stringWithFormat:@"screen_%@_image", type];
	}
	babyAnimalView._imageFileName = imageName;
	[babyAnimalView setNeedsDisplay];
}

- (void) updateEAGLEImageView {
	NSString *imageName;
	if (_currentImage == 0 || _currentImage == kSectionsPerLevel) {
		_babyAnimalEAGLView0._showSpeckles = YES;
		imageName = [NSString stringWithFormat:@"screen_%@_drawing_01", _type];
	} else if (_currentImage == 1) {
		_babyAnimalEAGLView0._showSpeckles = YES;
		imageName = [NSString stringWithFormat:@"screen_%@_word", _type];
	} else if (_currentImage == 2) {
		_babyAnimalEAGLView0._showSpeckles = NO;
		imageName = [NSString stringWithFormat:@"screen_%@_image", _type];
	}
	_babyAnimalEAGLView0._imageFileName = imageName;
	_currentImage++;
}

/* Removed because no swipe gestures anymore */
/*
- (void) updateSideImages {
	NSString *newType = _type;
	int newImage = _currentImage;
	int newLevel = _levelNum;
	
	// right
	if (newImage == kSectionsPerLevel) {
		newLevel++;
		if (newLevel == [_levels count]) {
			newLevel = 0;
		}
		newType = [NSString stringWithString:[[_levels objectAtIndex:newLevel] objectAtIndex:0]];
		newImage = 0;
	}
	[self updateImage:_babyAnimalView1 forIndex:newImage forType:newType];
	_babyAnimalView1.center = CGPointMake(_paperImageView.center.x, _paperImageView.center.y + 480);
	
	// left
	newType = _type;
	newImage = _currentImage - 2;
	newLevel = _levelNum;
	if (_currentImage == 1 || newImage < 0) {
		newLevel = _levelNum - 1;
		if (newLevel < 0) {
			newLevel = [_levels count] - 1;
		}
		newType = [NSString stringWithString:[[_levels objectAtIndex:newLevel] objectAtIndex:0]];
		newImage = 2;
	}
	[self updateImage:_babyAnimalView0 forIndex:newImage forType:newType];
	_babyAnimalView0.center = CGPointMake(_paperImageView.center.x, _paperImageView.center.y - 480);
}
 */

- (void) updateAnimationImage {
	_currentAnimation++;
	
	if (_currentAnimation > [_levelData count] - 1) {
		_currentAnimation = 1;
	}
	
	NSString *imageName = [NSString stringWithFormat:@"screen_%@_drawing_0%d", _type, [_levelData[_currentAnimation] intValue]];

	_babyAnimalEAGLView0._imageFileName = imageName;
	
	[self startAnimationTimer];
}

#pragma mark -
#pragma mark StartGame
- (void) startGame {
	self.view.alpha = 0.0;

	[self updateImage:_babyAnimalView forIndex:_currentImage forType:_type];
	_babyAnimalView.alpha = 1.0;
	
	_babyAnimalEAGLView0.alpha = 1.0;
	[self updateEAGLEImageView];
	
	/* Removed because no swipe gestures anymore */
	//[self updateSideImages];
	
	[self initializeViewAnimation];
}

- (void) updateImage {
	[self invalidateTimer];
	if (_soundIdentifier && [_soundIdentifier length] > 0) {
		[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] stopSound:_soundIdentifier];
	}
	
	[self crossFade];
}

/* Removed because no swipe gestures anymore */
/*
- (void) swipeImage {
	int newLevel, newImage;
	
	[self invalidateTimer];
	
	if (_soundIdentifier && [_soundIdentifier length] > 0) {
		[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] stopSound:_soundIdentifier];
	}
	
	if (_goBackwards) {
		newImage = _currentImage - 2;
		if (_currentImage == 1 || newImage < 0) {
			newLevel = _levelNum - 1;
			if (newLevel < 0) {
				newLevel = [_levels count] - 1;
			}
			[self setLevelNum:newLevel];
			_currentImage = 2;
			[self swipeAnimation];
		} else {
			_currentImage = newImage;
			[self swipeAnimation];
		}
	} else {
		[self swipeAnimation];
	}
}
 */

#pragma mark -
#pragma mark Touches

/* Removed because no swipe gestures anymore */
/*
// A tap starts game play
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch *touch = [touches anyObject];
	NSUInteger numTaps = [touch tapCount];
	_swiped = NO;
	_goBackwards = NO;
	if (numTaps < 2) {
		_gestureStartPoint = [touch locationInView:self.view];
		_swipeOffset = _babyAnimalEAGLView0.center.y - _gestureStartPoint.y;
	}
}

// A tap starts game play
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch *touch = [touches anyObject];
	CGPoint currentPosition = [touch locationInView:self.view];

	[self invalidateTimer];
	_babyAnimalEAGLView0.alpha = 1.0;
	_babyAnimalView.alpha = 0.0;
	_babyAnimalView0.alpha = 1.0;
	_babyAnimalView1.alpha = 1.0;
	
	_babyAnimalEAGLView0.center = CGPointMake(_paperImageView.center.x, currentPosition.y + _swipeOffset);
	
	if (_babyAnimalEAGLView0.center.y < 240) {
		// drag left
		_babyAnimalView1.center = CGPointMake(_paperImageView.center.x, _babyAnimalEAGLView0.center.y + 480);
	} else {
		// drag right
		_babyAnimalView0.center = CGPointMake(_paperImageView.center.x, _babyAnimalEAGLView0.center.y - 480);
	}
}
*/
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	/* Removed because no swipe gestures anymore */
	/*
	UITouch *touch = [touches anyObject];
	NSUInteger numTaps = [touch tapCount];	
	CGPoint currentPosition = [touch locationInView:self.view];
	CGFloat deltaX = fabsf(_gestureStartPoint.x - currentPosition.x);
	CGFloat deltaY = fabsf(_gestureStartPoint.y - currentPosition.y);
	 */
	
	self.view.userInteractionEnabled = NO;
	
	/* Removed because no swipe gestures anymore */
	/*
	if (numTaps == 0) {
		if (deltaY > kMinimumGestureLength && deltaX < deltaY) {
			_swiped = YES;
			if (_gestureStartPoint.y < currentPosition.y) {
				_goBackwards = YES;
			}
			
			[self swipeImage];

		} else {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:kViewFadeTime/2.0];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(snapBackDone)];
			
			_babyAnimalEAGLView0.center = _paperImageView.center;
			
			if (currentPosition.y + _swipeOffset < 240) {
				// was dragging left
				_babyAnimalView1.center = CGPointMake(_paperImageView.center.x, _paperImageView.center.y + 480);
			} else {
				// was dragging right
				_babyAnimalView0.center = CGPointMake(_paperImageView.center.x, _paperImageView.center.y - 480);
			}
			
			[UIView commitAnimations];
		}
	} 
	 */
	//if (numTaps == 1) {
		/* Removed because no swipe gestures anymore */
		//[self snapBack];
		//NSTimer *timer;
		//timer = [NSTimer scheduledTimerWithTimeInterval:(kViewFadeTime/2.0) target:self selector:@selector(updateImage) userInfo:nil repeats:NO];
		[self updateImage];
	//}
}

#pragma mark -
#pragma mark Sound

- (void) playSoundIdentifier {
	if (_currentImage == 1) {
		_soundIdentifier = [[NSString alloc] initWithFormat:@"VO_%@", _type];
		[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] playSound:_soundIdentifier restart:YES];
	} else if (_currentImage == 2) {
		_soundIdentifier = [[NSString alloc] initWithFormat:@"VO_%@", _type];
		[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] playSound:_soundIdentifier restart:YES];

		_paperImageView.alpha = 1.0;
		_screenBlinkIndex = 0;
		//[self blinkScreen];
		_timer = [NSTimer scheduledTimerWithTimeInterval:(kViewFadeTime) target:self selector:@selector(blinkScreen) userInfo:nil repeats:NO];
	} else if (_currentImage == 3) {
		_soundIdentifier = [[NSString alloc] initWithFormat:@"SFX_%@", _type];
		[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] playSound:_soundIdentifier restart:YES];
		
		_timer = [NSTimer scheduledTimerWithTimeInterval:(kViewFadeTime) target:self selector:@selector(checkIfSFXPlaying) userInfo:nil repeats:NO];
		
	}
}

- (void) playLevelSound {
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] playSound:kNewLevelAudio restart:YES];
}

- (void) playScreenSound {
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] playSound:kNewScreenAudio restart:YES];
}

- (void) checkIfSFXPlaying {
	BOOL soundPlaying = [(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] soundPlaying:_soundIdentifier];
	if (soundPlaying) {
		_timer = [NSTimer scheduledTimerWithTimeInterval:(kViewFadeTime) target:self selector:@selector(checkIfSFXPlaying) userInfo:nil repeats:NO];
	} else {
		_timer = nil;
		_soundIdentifier = [[NSString alloc] initWithFormat:@"VO_%@", _type];
		[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] playSound:_soundIdentifier restart:YES];
	}
}

#pragma mark -
#pragma mark Blink screen

- (void) blinkScreen {
	if (_screenBlinkIndex % 2 == 0) {
		_babyAnimalEAGLView0.alpha = 0.0;
		_babyAnimalView.alpha = 0.0;
	} else {
		_babyAnimalEAGLView0.alpha = 10.0;
		_babyAnimalView.alpha = 1.0;
	}
	
	_screenBlinkIndex++;
	if (_screenBlinkIndex < _screenBlinkMax) {
		if (_screenBlinkIndex % 2 == 1) {
			_timer = [NSTimer scheduledTimerWithTimeInterval:(kBlinkTimeOff) target:self selector:@selector(blinkScreen) userInfo:nil repeats:NO];
		} else {
			_timer = [NSTimer scheduledTimerWithTimeInterval:(kBlinkTimeOn) target:self selector:@selector(blinkScreen) userInfo:nil repeats:NO];
		}
	} else {
		_timer = nil;
	}
}

- (void) playDelayedSound {
	_timer = nil;
	_soundIdentifier = [[NSString alloc] initWithFormat:@"VO_%@", _type];
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] playSound:_soundIdentifier restart:YES];
}

#pragma mark -
#pragma mark Screen snapped back after dragging
- (void) invalidateTimer {
	if (_timer) {
		[_timer invalidate];
		_timer = nil;
	}
}

#pragma mark -
#pragma mark Screen snapped back after dragging
/* Removed because no swipe gestures anymore */
/*
- (void) snapBackDone {
	self.view.userInteractionEnabled = YES;
	
	if (_currentImage == 1) {
		[self startAnimationTimer];
	}
}

- (void) snapBack {
	_babyAnimalEAGLView0.center = _paperImageView.center;
}
*/

#pragma mark -
#pragma mark Accessors

- (unsigned) levelNum {
	return _levelNum;
}
- (void) setLevelNum:(unsigned)newLevelNum {
	_currentImage = 0;
	_animationStarted = NO;
	_currentAnimation = 1;
	_levelNum = newLevelNum;
	_levelData = _levels[_levelNum];
	_type = [[NSString alloc] initWithString:_levelData[0]];
}

- (void) setLevelData:(NSArray*)newLevelData {
	_levels = [[NSArray alloc] initWithArray:newLevelData];
}

@end