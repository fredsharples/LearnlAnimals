//
//  IntroViewController.m
//  BabyAnimals
//
//  Created by Fred Sharples on 4/18/13.
//
//

#import "IntroViewController.h"


@interface IntroViewController ()

@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// A tap starts game play
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	
	[self fadeView];
}


- (void) fadeView {
	[self invalidateTimer];
	
	self.view.userInteractionEnabled = NO;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kViewFadeTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeView)];
	self.view.alpha = 0.0;
	[UIView commitAnimations];
}

- (void) invalidateTimer {
	if (_timer) {
		[_timer invalidate];
		_timer = nil;
	}
}

- (void) removeView {
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] changeState:kGameState_Title];
}
- (void)dealloc {
    //[_background release];
   // [_background release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self set_background:nil];
    [self set_background:nil];
    [super viewDidUnload];
}
@end
