//
//  BabyAnimalsAppDelegate.m
//  BabyAnimals
//
//  Created by Susan Surapruik on 9/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BabyAnimalsAppDelegate.h"
#import "OpenALPlayer.h"
#import "LegalViewController.h"
#import "TitleViewController.h"
#import "GameViewController.h"
#import "CheatViewController.h"

@implementation BabyAnimalsAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Orientations
// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskLandscape;
	
	// iPad only
	return UIInterfaceOrientationMaskLandscape;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark -
#pragma mark Life Cycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	_pause = NO;
	
	//_gameViewController = [[GameViewController alloc] init];

	_openALPlayer = [[OpenALPlayer alloc] init];
	
	[self createSaveData];
	
#ifdef DEBUG
		_cheatButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_cheatButton.backgroundColor = [UIColor clearColor];
		_cheatButton.frame = CGRectMake(0, 0, 40, 40);
		[_cheatButton addTarget:self action:@selector(cheat:) forControlEvents:UIControlEventTouchUpInside];
		[window addSubview:_cheatButton];
#endif
	
	// Show legal screen
	[self changeState:kGameState_Legal];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
//	[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
	window.autoresizesSubviews = YES;
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	//[_saveData setValue:[NSNumber numberWithInteger:[_gameViewController levelNum]] forKey:@"LevelNum"];
	if (_gameViewController) {
		[_saveData setValue:[NSNumber numberWithInteger:[_gameViewController levelNum]] forKey:@"LevelNum"];
	} else {
		[_saveData setValue:[NSNumber numberWithInteger:_levelNum] forKey:@"LevelNum"];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:_saveData forKey:kGameDataKey];
}

#pragma mark -
#pragma mark Memory Management


#pragma mark -
#pragma mark Application Initialization

- (void) createSaveData {
	// Read saved data
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
	NSDictionary *_gameData = [NSDictionary dictionaryWithContentsOfFile:filePath]; 
	// load the stored preference of the user's last location from a previous launch
	_saveData = [[[NSUserDefaults standardUserDefaults] objectForKey:kGameDataKey] mutableCopy];
	if (_saveData == nil) {
		_saveData = [NSMutableDictionary dictionaryWithCapacity:[_gameData count]];
		[_saveData setDictionary:[_gameData valueForKey:@"GameData"]];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:_saveData forKey:kGameDataKey];
	_saveData = [[[NSUserDefaults standardUserDefaults] objectForKey:kGameDataKey] mutableCopy];
	
	NSDictionary *savedLocationDict = [NSDictionary dictionaryWithObject:_saveData forKey:kGameDataKey];
	[[NSUserDefaults standardUserDefaults] registerDefaults:savedLocationDict];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	_levels = [[NSArray alloc] initWithArray:[_gameData valueForKey:@"Levels"]];
	_levelNum = [[_saveData valueForKey:@"LevelNum"] unsignedIntValue];
	_titleData = [[NSArray alloc] initWithArray:[_gameData valueForKey:@"Title"]];
}

#pragma mark -
#pragma mark State Changes

- (void) changeState:(unsigned)state {
	if (_viewController && [_viewController view] && [[_viewController view] superview]) {
		[[_viewController view] removeFromSuperview];
		_viewController = nil;
	}
	
	if (state == kGameState_Legal) {
		_viewController = [[LegalViewController alloc] init];
		[window addSubview:[_viewController view]];
	} else if (state == kGameState_Title) {
		_viewController = [[TitleViewController alloc] init];
		[_viewController setLevelData:_titleData];
		[window addSubview:[_viewController view]];
	} else if (state == kGameState_Game) {
		if (_gameViewController) {
			[_gameViewController setLevelNum:_levelNum];
		} else {
			_gameViewController = [[GameViewController alloc] init];
			[_gameViewController setLevelData:_levels];
			[_gameViewController setLevelNum:_levelNum];
		}
		
		[window addSubview:[_gameViewController view]];
		[_gameViewController startGame];
	} else if (state == kGameState_Cheat) {
		[_openALPlayer stopAllSoundsExcept:@""];
		_viewController = [[CheatViewController alloc] init];
		
		if (_gameViewController) {
			[_viewController arrangeViewForLevel:[_gameViewController levelNum]];
		} else {
			[_viewController arrangeViewForLevel:_levelNum];
		}

		[window addSubview:[_viewController view]];
		
		_paperImageView.alpha = 0.0;
	}
	
#ifdef DEBUG
		[window bringSubviewToFront:_cheatButton];
#endif
	
	_state = state;
}

- (void) resetGame:(unsigned)levelNum {
	_levelNum = levelNum;
	//[_gameViewController setLevelNum:levelNum];
	[self changeState:kGameState_Game];
}

#pragma mark -
#pragma mark Play Sounds

- (void) setSoundLoop:(NSString*)identifier loop:(BOOL)loop {
	[_openALPlayer setSoundLoop:identifier loop:loop];
}

- (BOOL) soundPlaying:(NSString*)identifier {
	return [_openALPlayer soundPlaying:identifier];
	//return [_soundManager soundPlaying:identifier];
}

- (void) playSound:(NSString*)identifier restart:(BOOL)restart {
	[_openALPlayer playSound:identifier restart:restart];
	//[_soundManager playSound:identifier restart:restart];
}

- (void) fadeSoundIn:(NSString*)identifier {
	[_openALPlayer fadeSoundIn:identifier];
}

- (void) stopSound:(NSString*)identifier {
	[_openALPlayer stopSound:identifier];
}

- (void) fadeSoundOut:(NSString*)identifier {
	[_openALPlayer fadeSoundOut:identifier];
}

#pragma mark -
#pragma mark Cheat

- (void) cheat:(id)sender {
	[self changeState:kGameState_Cheat];
}

#pragma mark -
#pragma mark OpenAL Getter/Setter

- (OpenALPlayer*) _openALPlayer {
	return _openALPlayer;
}

- (void) set_openALPlayer:(OpenALPlayer*)newOpenALPlayer {
	_openALPlayer = newOpenALPlayer;
}

@end