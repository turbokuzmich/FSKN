//
//  FSKN_2AppDelegate.m
//  FSKN 2
//
//  Created by Дмитрий on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FSKN_2AppDelegate.h"

#import "RootViewController.h"

#import "StartScreenViewController.h"

#import "ScrollViewController.h"

#import "MainScreenViewController.h"

#import "GeographyViewController.h"

#import "ThesisViewController.h"

#import "StructureViewController.h"

#import "BiographyViewController.h"

#import "DrugMapViewController.h"

@implementation FSKN_2AppDelegate


@synthesize window=_window;

@synthesize splitViewController=_splitViewController;

@synthesize rootViewController=_rootViewController;

@synthesize detailViewController=_detailViewController;

@synthesize startScreenWindow;

@synthesize startScreenViewController;

@synthesize statisticsWindow;

@synthesize statisticsViewController;

@synthesize mainScreenWindow;

@synthesize mainScreenViewController;

@synthesize georgaphyWindow;

@synthesize geographyViewController;

@synthesize internationalWindow;

@synthesize internationalSplitViewController;

@synthesize thesisWindow;

@synthesize thesisController;

@synthesize structureWindow;

@synthesize structureController;

@synthesize biographyWindow;

@synthesize biographyController;

@synthesize drugMapWindow;

@synthesize drugMapController;

@synthesize magazineWindow;

@synthesize magazineNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the split view controller's view to the window and display.
    
    self.startScreenWindow.rootViewController = self.startScreenViewController;
    [self.startScreenWindow makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [magazineWindow release];
    [magazineNavigationController release];
    [drugMapWindow release];
    [drugMapController release];
    [biographyWindow release];
    [biographyController release];
    [structureWindow release];
    [structureController release];
    [thesisWindow release];
    [thesisController release];
    [internationalWindow release];
    [internationalSplitViewController release];
    [georgaphyWindow release];
    [geographyViewController release];
    [mainScreenWindow release];
    [mainScreenViewController release];
    [statisticsWindow release];
    [statisticsViewController release];
    [startScreenWindow release];
    [startScreenViewController release];
    [_window release];
    [_splitViewController release];
    [_rootViewController release];
    [_detailViewController release];
    [super dealloc];
}


-(void)goToMain
{
    self.mainScreenWindow.rootViewController = self.mainScreenViewController;
    [self.mainScreenWindow makeKeyAndVisible];
}

-(void)goToGeography
{
    self.georgaphyWindow.rootViewController = self.geographyViewController;
    [self.georgaphyWindow makeKeyAndVisible];
}

- (void)goToStatistics
{
    self.statisticsWindow.rootViewController = self.statisticsViewController;
    [self.statisticsWindow makeKeyAndVisible];
}

- (void)goToDocuments
{
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
}

- (void)goToInternational
{
    self.internationalWindow.rootViewController = self.internationalSplitViewController;
    [self.internationalWindow makeKeyAndVisible];
}

- (void)goToThesis
{
    self.thesisWindow.rootViewController = self.thesisController;
    [self.thesisWindow makeKeyAndVisible];
}

- (void)goToStructure
{
    self.structureWindow.rootViewController = self.structureController;
    [self.structureWindow makeKeyAndVisible];
}

- (void)goToBlog
{
    NSURL *blogUrl = [NSURL URLWithString:@"http://vp-ivanov.livejournal.com/"];
    [[UIApplication sharedApplication] openURL:blogUrl];
}

- (void)goToStrategy
{
    NSURL *blogUrl = [NSURL URLWithString:@"http://stratgap.ru/"];
    [[UIApplication sharedApplication] openURL:blogUrl];
}

- (void)goToBiography
{
    self.biographyWindow.rootViewController = self.biographyController;
    [self.biographyWindow makeKeyAndVisible];
}

- (void)goToDrugMap
{
    self.drugMapWindow.rootViewController = self.drugMapController;
    [self.drugMapWindow makeKeyAndVisible];
}

-(void)goToYoutube
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Видео" message:@"К сожалению, данная функция пока не работает" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)goToMagazine
{
    self.magazineWindow.rootViewController = self.magazineNavigationController;
    [self.magazineWindow makeKeyAndVisible];
}


@end
