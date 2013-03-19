//
//  BabyAnimalViewController.h
//  BabyAnimals
//
//  Created by Susan Surapruik on 9/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzView.h"

@interface BabyAnimalView : QuartzView {
	CGImageRef _image;
	CGImageRef _speckle;
	CGImageRef _paper;
	
	NSString *_imageFileName;
	
	BOOL _showSpeckles;
}

- (void) initializeMe;

@property(nonatomic, strong) NSString *_imageFileName;
@property BOOL _showSpeckles;

@end
