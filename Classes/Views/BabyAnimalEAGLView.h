//
//  BabyAnimalEAGLView.h
//  BabyAnimals
//
//  Created by Susan Surapruik on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyEAGLView.h"
#import "Constants.h"

@interface BabyAnimalEAGLView : MyEAGLView {
	Texture2D *_image;
	Texture2D *_speckle;
	Texture2D *_paper;
	
	BOOL _firstDraw;
	NSString *_imageFileName;
	
	BOOL _showSpeckles;
	
	NSTimer *_timer;
}

- (void) initializeView;
- (void) drawView;
- (void) startDrawTimer:(BOOL)start;

@property(nonatomic, retain) NSString *_imageFileName;
@property BOOL _showSpeckles;

@end
