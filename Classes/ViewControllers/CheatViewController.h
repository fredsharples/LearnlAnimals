//
//  CheatViewController.h
//
//  Created by Susan Surapruik on 7/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface CheatViewController : ViewController <UIPickerViewDelegate> {
	UILabel *_textField;
	unsigned _levelNum;
}

- (void) startGame:(id)sender;
- (CGRect)pickerFrameWithSize:(CGSize)size;

@end