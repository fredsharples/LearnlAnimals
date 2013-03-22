//
//  BabyAnimalViewController.m
//  BabyAnimals
//
//  Created by Susan Surapruik on 9/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BabyAnimalView.h"
#import "Constants.h"

@implementation BabyAnimalView

@synthesize _showSpeckles;

- (id)initWithCoder:(NSCoder*)coder {
	if ((self = [super initWithCoder:coder])) {
		[self initializeMe];
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self != nil) {
		[self initializeMe];
	}
	return self;
}

- (void) initializeMe {
	UIImage *img0, *img1;
	
	_showSpeckles = YES;
	
	img0 = [UIImage imageNamed:kImage_Speckle];
	_speckle = CGImageRetain(img0.CGImage);
	
	img1 = [UIImage imageNamed:kImage_Paper];
	_paper = CGImageRetain(img1.CGImage);
}

-(void)drawInContext:(CGContextRef)context {
	// Expects a Lower-Left coordinate system, so we flip the coordinate system before drawing.
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	if (_imageFileName) {
		CGContextSetBlendMode(context, kCGBlendModeCopy);
		CGContextDrawImage(context, self.bounds, _image);
	}
	if (_showSpeckles) {
		CGContextSetBlendMode(context, kCGBlendModeScreen);
		CGContextDrawImage(context, self.bounds, _speckle);
	}
	CGContextSetBlendMode(context, kCGBlendModeMultiply);
	CGContextDrawImage(context, self.bounds, _paper);
}

- (void)dealloc {
	CGImageRelease(_image);
	CGImageRelease(_speckle);
	CGImageRelease(_paper);
	

}



- (void) set_imageFileName:(NSString*)newImageFileName {
	NSString *imagePath;
	UIImage *img0;
	
	if (_imageFileName) {
		CGImageRelease(_image);
	}
	
	_imageFileName = [[NSString alloc] initWithString:newImageFileName];
	
	imagePath = [[NSBundle mainBundle] pathForResource:_imageFileName ofType:@"png"];
	img0 = [UIImage imageWithContentsOfFile:imagePath];
	_image = CGImageRetain(img0.CGImage);
}
- (NSString*) _imageFileName {
	return _imageFileName;
}

@end
