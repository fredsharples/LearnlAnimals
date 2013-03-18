/*
 *  Constants.h
 *  MadrigalChallenge
 *
 *  Created by Susan Surapruik on 7/14/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#import <mach/mach_time.h>
#import "Texture2D.h"

typedef enum {
	kGameState_StandBy = 0,
	kGameState_Cheat,
	kGameState_Legal,
	kGameState_Title,
	kGameState_Game
} GameState;

#define kNumLevels				20

#define kGameDataKey			@"GameData"	// preference key to obtain our restore location

#define kMinimumGestureLength	200.0 // pixels

#define kLegalTimeOut			5.0 // seconds legal screen is visible

#define kViewFadeTime			0.75 // fade transition in seconds

#define kBlinkTimeOn			0.5
#define kBlinkTimeOff			0.5

#define kSectionsPerLevel		3

#define kRenderingFPS			24.0 // Hz

#define kImage_Paper			@"paper_00.png"
#define kImage_Speckle			@"speckle_00.png"
#define kNewScreenAudio			@"SFX_nextScreen"
#define kNewLevelAudio			@"SFX_nextAnimal"
#define kTitleAudio				@"VO_title"

#define kURLRequest				@"http://www.learnl.net"