//
//  BabyAnimalsAppDelegate.h
//  BabyAnimals
//
//  Created by Susan Surapruik on 9/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import "Constants.h"

@class OpenALPlayer;
@class ViewController;
@class GameViewController;

@interface BabyAnimalsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	ViewController *_viewController;
	GameViewController *_gameViewController;
	
	IBOutlet UIImageView *_paperImageView;
	
	NSMutableDictionary *_saveData;
	
	UIButton *_cheatButton;
	
	OpenALPlayer *_openALPlayer;
	
	BOOL _pause;
	CFTimeInterval _pauseTime;
	
	NSTimer *_timer;
	
	GameState _state;
	
	NSArray *_levels;
	unsigned _levelNum;
	NSArray *_titleData;
}

- (void) createSaveData;

- (void) resetGame:(unsigned)levelNum;

- (void) changeState:(unsigned)state;

- (void) setSoundLoop:(NSString*)identifier loop:(BOOL)loop;
- (BOOL) soundPlaying:(NSString*)identifier;
- (void) playSound:(NSString*)identifier restart:(BOOL)restart;
- (void) fadeSoundIn:(NSString*)identifier;
- (void) stopSound:(NSString*)identifier;
- (void) fadeSoundOut:(NSString*)identifier;

@property (nonatomic, strong) IBOutlet UIWindow *window;
//@property (nonatomic, retain) SoundEngineManager *_soundManager;
@property (nonatomic, strong) OpenALPlayer *_openALPlayer;

@end
