//
//  GameViewController.h
//  BabyAnimals
//
//  Created by Susan Surapruik on 9/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BabyAnimalEAGLView;
@class BabyAnimalView;

@interface GameViewController : UIViewController {
	NSString *_type;
	unsigned _currentImage;
	BOOL _animationStarted;
	unsigned _currentAnimation;
	NSString *_soundIdentifier;
	
	IBOutlet BabyAnimalEAGLView *_babyAnimalEAGLView0;
	IBOutlet BabyAnimalView *_babyAnimalView;
	/* Removed because no swipe gestures anymore */
	//IBOutlet BabyAnimalView *_babyAnimalView0;
	//IBOutlet BabyAnimalView *_babyAnimalView1;
	
	unsigned _levelNum;
	NSArray *_levels;
	NSArray *_levelData;
	
	/* Removed because no swipe gestures anymore */
	//BOOL _swiped;
	//BOOL _goBackwards;
	//CGPoint _gestureStartPoint;
	//int _swipeOffset;
	
	NSTimer *_timer;
	
	IBOutlet UIImageView *_paperImageView;
	unsigned _screenBlinkIndex;
	unsigned _screenBlinkMax;
}

- (void) startGame;
- (NSString*) getImageFileName:(unsigned)imageIndex forType:(NSString*)type;
- (BOOL) getSpeckleVisible:(unsigned)imageIndex forType:(NSString*)type;
- (void) updateImage;

- (void) crossFade;
- (void) viewFadedIn;
- (void) updateImage:(BabyAnimalView*)babyAnimalView forIndex:(unsigned)imageIndex forType:(NSString*)type;
- (void) updateEAGLEImageView;

- (void) startAnimationTimer;
- (void) updateAnimationImage;

- (void) playSoundIdentifier;

- (unsigned) levelNum;
- (void) setLevelNum:(unsigned)newLevelNum;

- (void) setLevelData:(NSArray*)newLevelData;

- (void) invalidateTimer;

/* Removed because no swipe gestures anymore */
//- (void) swipeImage;
//- (void) swipeAnimation;
//- (void) snapBack;
//- (void) updateSideImages;

@end