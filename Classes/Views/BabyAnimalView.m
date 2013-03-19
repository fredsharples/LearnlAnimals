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
	
	// Start with a background whose color we don't use in the demo
/*
	CGColorRef white = [UIColor whiteColor].CGColor;
	CGContextSetFillColorWithColor(context, white);
	CGContextFillRect(context, self.bounds);
 */
	
	// We're about to modify the context CTM to draw the PDF page where we want it, so save the graphics state in case we want to do more drawing
	//CGContextSaveGState(context);
	
	
	/*
	 // Note: The images are actually drawn upside down because Quartz image drawing expects
	 // the coordinate system to have the origin in the lower-left corner, but a UIView
	 // puts the origin in the upper-left corner. For the sake of brevity (and because
	 // it likely would go unnoticed for the image used) this is not addressed here.
	 // For the demonstration of PDF drawing however, it is addressed, as it would definately
	 // be noticed, and one method of addressing it is shown there.
	 */
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
