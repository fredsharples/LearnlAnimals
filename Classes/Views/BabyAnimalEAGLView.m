//
//  BabyAnimalEAGLView.m
//  BabyAnimals
//
//  Created by Susan Surapruik on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BabyAnimalEAGLView.h"
#import "BabyAnimalsAppDelegate.h"

@implementation BabyAnimalEAGLView

@synthesize _showSpeckles;

-(id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self != nil) {
		[self initializeView];
	}
	return self;
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
	if ((self = [super initWithCoder:coder])) {
		[self initializeView];
	}
	
	return self;
}

- (void) initializeView {
	CGRect rect = [self bounds];
	
	//Set up OpenGL projection matrix
	glMatrixMode(GL_PROJECTION);
	glOrthof(0, rect.size.width, 0, rect.size.height, -1, 1);
	glMatrixMode(GL_MODELVIEW);
	
	//Initialize OpenGL states
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	//glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_TEXTURE_2D);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	//glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	//glEnable(GL_BLEND);
	
	_firstDraw = YES;
	_showSpeckles = YES;
	_imageFileName = [[NSString alloc] initWithString:@""];
	
	_speckle =  [[Texture2D alloc] initWithImage: [UIImage imageNamed:kImage_Speckle]];
	_paper = [[Texture2D alloc] initWithImage: [UIImage imageNamed:kImage_Paper]];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void) drawView {
	_firstDraw = NO;

	glDisable(GL_BLEND);
	[_image drawInRect:self.bounds];
	//[_image drawInRect:self.bounds srcEnum:GL_ONE dstEnum:GL_ZERO];
	
	glEnable(GL_BLEND);
	if (_showSpeckles) {
		[_speckle drawInRect:self.bounds srcEnum:GL_ONE dstEnum:GL_ONE_MINUS_SRC_COLOR];
	}
	
	[_paper drawInRect:self.bounds srcEnum:GL_DST_COLOR dstEnum:GL_ZERO];

	[self swapBuffers];
}

- (void) startDrawTimer:(BOOL)start {
	if (start) {
		if (_timer == nil) {
			_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / kRenderingFPS) target:self selector:@selector(drawView) userInfo:nil repeats:YES];
		}
	} else {
		if (_timer) {
			[_timer invalidate];
			_timer = NULL;
		}
	}
}


- (void)dealloc {
	[self startDrawTimer:NO];
	
	[_image release];
	[_speckle release];
	[_paper release];
	
	[_imageFileName release];
	
    [super dealloc];
}

- (void) set_imageFileName:(NSString*)newImageFileName {
	NSString *imagePath;
	
	if (_firstDraw || [newImageFileName localizedCompare:_imageFileName] != NSOrderedSame) {
		if (!_firstDraw) {
			[_image release];
			[_imageFileName release];
		}
		
		_imageFileName = [[NSString alloc] initWithString:newImageFileName];
		
		imagePath = [NSString stringWithFormat:@"%@.png", _imageFileName];
		_image = [[Texture2D alloc] initWithImage: [UIImage imageNamed:imagePath]];
		
		[self drawView];
	}
}
- (NSString*) _imageFileName {
	return _imageFileName;
}

@end
