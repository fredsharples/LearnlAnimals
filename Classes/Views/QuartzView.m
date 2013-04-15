/*
     File: QuartzView.m
 Abstract: A UIView subclass that is the super class of the other views demonstrated in this sample.
  Version: 2.2
*/

#import "QuartzView.h"

@implementation QuartzView

-(id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self != nil) {
		//self.backgroundColor = [UIColor whiteColor];
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

-(void)drawInContext:(CGContextRef)context {
	// Default is to do nothing!
}

-(void)drawRect:(CGRect)rect {
	// Since we use the CGContextRef a lot, it is convienient for our demonstration classes to do the real work
	// inside of a method that passes the context as a parameter, rather than having to query the context
	// continuously, or setup that parameter for every subclass.
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void) clearContext:(BOOL)updateDisplay {
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	if (contextRef) {
		CGContextClearRect(UIGraphicsGetCurrentContext(), [self bounds]);
		if (updateDisplay) {
			[self setNeedsDisplay];
		}
	}
}
- (void) dealloc {
	[super dealloc];
}

@end