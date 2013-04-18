//
//  LegalViewController.h
//  MadrigalChallenge
//
//  Created by Susan Surapruik on 7/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BabyAnimalViewController.h"

@interface LegalViewController : BabyAnimalViewController {
   IBOutlet LegalViewController *_legalView;
	UIButton *_moreGamesButton;
	UIImageView *_noWebConnection;
    //IBOutlet UIImageView *background;
   // IBOutlet UIView *_legalView;
}

- (BOOL) connectedToNetwork:(NSString*)urlString;

@end