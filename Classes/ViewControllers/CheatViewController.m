//
//  CheatViewController.m
//
//  Created by Susan Surapruik on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CheatViewController.h"

@implementation CheatViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[self initializeView];
	self.view.backgroundColor = [UIColor blackColor];
	self.view.opaque = YES;
	[self initializeViewAnimation];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	[_textField removeFromSuperview];
	
}

- (void) arrangeViewForLevel:(int)levelNum {
	_textField = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
	_textField.backgroundColor = [UIColor clearColor];
	_textField.textColor = [UIColor whiteColor];
	_textField.textAlignment = UITextAlignmentCenter;
	_textField.text = @"BUILD 14";
	[self.view addSubview:_textField];
	
	CGRect rect = [self.view bounds];
	CGFloat buttonX = (rect.size.width - 100) / 2;
	
	if (levelNum < 0) {
		levelNum = 0;
	}
	_levelNum = levelNum;
	
	// note we are using CGRectZero for the dimensions of our picker view,
	// this is because picker views have a built in optimum size,
	// you just need to set the correct origin in your view.
	//
	// position the picker at the bottom
	UIPickerView *levelPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
	CGSize pickerSize = [levelPicker sizeThatFits:CGSizeZero];
	levelPicker.frame = [self pickerFrameWithSize:pickerSize];
	
	levelPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	levelPicker.delegate = self;
	levelPicker.showsSelectionIndicator = YES;	// note this is default to NO
	
	[levelPicker selectRow:_levelNum inComponent:0 animated:YES];
	
	// add this picker to our view controller, initially hidden
	[self.view addSubview:levelPicker];
	
	UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
	btn0.backgroundColor = [UIColor whiteColor];
	btn0.frame = CGRectMake(buttonX, 250, 100, 40);
	[btn0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[btn0 setTitle:@"GO" forState:UIControlStateNormal];
	[btn0 addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn0];	

}

- (void) removeView {
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] changeState:kGameState_Game];
}

- (void) startGame:(id)sender {
	[(BabyAnimalsAppDelegate*)[[UIApplication sharedApplication] delegate] resetGame:_levelNum];
}

// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size {
	CGRect pickerRect = CGRectMake(	0, 20, size.width, size.height);
	return pickerRect;
}

#pragma mark -
#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	// change the left most bar item to what's in the picker
	_levelNum = [pickerView selectedRowInComponent:0];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%d", (row + 1)];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 240.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return kNumLevels;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}


@end