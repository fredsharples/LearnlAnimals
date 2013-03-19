//
//  main.m
//  BabyAnimals
//
//  Created by Susan Surapruik on 9/9/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    //int retVal = UIApplicationMain(argc, argv, nil, nil);
    int retVal = UIApplicationMain(argc, argv, nil, @"BabyAnimalsAppDelegate");
    [pool release];
    return retVal;
    
}

