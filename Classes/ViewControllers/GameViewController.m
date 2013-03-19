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
	
	_soundIdentifier = [[NSString alloc] initWithString:@""];
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
	
	[_levelData release];
	[_levels release];
	
	[_paperImageView release];
	
	[_babyAnimalEAGLView0 release];
	[_babyAnimalView release];
	
	
	[_soundIdentifier release];
	[_type release];
	
    [super dealloc];
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


- (void) viewFadedIn {
	//NSTimer *timer;
	
	[self updateImage:_babyAnimalView forIndex:_currentImage forType:_type];
	
	[self updateEAGLEImageView];
	_babyAnimalEAGLView0.alpha = 1.0;
	
	
	
	[self playSoundIdentifier];
	
	if (_currentImage == 1) {
		[self startAnimationTimer];
	}
	self.view.userInteractionEnabled = YES;

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


- (void) updateAnimationImage {
	_currentAnimation++;
	
	if (_currentAnimation > [_levelData count] - 1) {
		_currentAnimation = 1;
	}
	
	NSString *imageName = [NSString stringWithFormat:@"screen_%@_drawing_0%d", _type, [[_levelData objectAtIndex:_currentAnimation] intValue]];

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
	
	
	[self initializeViewAnimation];
}

- (void) updateImage {
	[self invalidateTimer];
	if (_soundIdentifier && [_soundIdentifier length] > 0) {
		[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] stopSound:_soundIdentifier];
	}
	
	[self crossFade];
}


- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
		[self updateImage];
}

#pragma mark -
#pragma mark Sound

- (void) playSoundIdentifier {
	[_soundIdentifier release];
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
		[_soundIdentifier release];
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

- (void) invalidateTimer {
	if (_timer) {
		[_timer invalidate];
		_timer = nil;
	}
}



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
	_levelData = [_levels objectAtIndex:_levelNum];
	[_type release];
	_type = [[NSString alloc] initWithString:[_levelData objectAtIndex:0]];
}

- (void) setLevelData:(NSArray*)newLevelData {
	_levels = [[NSArray alloc] initWithArray:newLevelData];
}

@end