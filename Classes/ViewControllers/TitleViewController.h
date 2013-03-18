//
//  TitleViewController.h
//  MadrigalChallenge
//
//  Created by Susan Surapruik on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BabyAnimalEAGLView;

@interface TitleViewController : UIViewController {
	IBOutlet BabyAnimalEAGLView *_babyAnimalEAGLView0;
	
	NSString *_type;
	BOOL _animationStarted;
	unsigned _currentAnimation;
	NSArray *_levelData;
	
	NSTimer *_timer;
}

- (void) fadeView;
- (void) setLevelData:(NSArray*)newLevelData;
- (void) startAnimationTimer;
- (void) updateAnimationImage;
- (void) invalidateTimer;

@end