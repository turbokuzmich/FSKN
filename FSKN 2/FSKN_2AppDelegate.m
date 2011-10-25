//
//  FSKN_2AppDelegate.m
//  FSKN 2
//
//  Created by Дмитрий on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define LATEST_MAGAZINE_URL "http://dima2.local.crmm.ru/latest.publication.php"

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
#import "MagazineRootViewController.h"

@implementation FSKN_2AppDelegate


NSMutableData *latestMagazineData = nil;
NSString *latestMagazineID = nil;



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

@synthesize magazineRootViewController;

@synthesize magazineImageView;

@synthesize loadMagazineButton;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.startScreenWindow.rootViewController = self.startScreenViewController;
    [self.startScreenWindow makeKeyAndVisible];
    
    // скачиваем инфу про последний журнал
    latestMagazineData = [[NSMutableData alloc] init];
    NSURLRequest *latestMagazineRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@LATEST_MAGAZINE_URL]];
    NSURLConnection *latestMagazineConnection = [NSURLConnection connectionWithRequest:latestMagazineRequest delegate:self];
    [latestMagazineConnection retain];
    
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
    [loadMagazineButton release];
    [magazineImageView release];
    [magazineRootViewController release];
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



- (void)loadLatestMagazine
{
    self.magazineRootViewController.publicationToShow = latestMagazineID;
    [self goToMagazine];
    
    // переход на самый последний журнал по ссылки с главной страницы
    if (self.magazineRootViewController.publicationToShow != nil) {
        for (NSDictionary *pub in self.magazineRootViewController.localPublications) {
            if ([[pub valueForKey:@"id"] isEqualToString:self.magazineRootViewController.publicationToShow]) {
                [self.magazineRootViewController showPublicationWithID:self.magazineRootViewController.publicationToShow];
                self.magazineRootViewController.publicationToShow = nil;
                break;
            }
        }
    }
    
    // если не нашли журнал локально
    if (self.magazineRootViewController.publicationToShow) {
        [self.magazineRootViewController loadPublicationsXml];
    }
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load latest magazine cover %@", error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [latestMagazineData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [latestMagazineData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[[NSString alloc] initWithData:latestMagazineData encoding:NSUTF8StringEncoding] autorelease];
    NSArray *parts = [response componentsSeparatedByString:@"\n"];

    latestMagazineID = [[parts objectAtIndex:0] retain];
    NSString *cover = [parts objectAtIndex:1];
    
    // проверяем, имеется ли журнальчик
    NSFileManager *df = [NSFileManager defaultManager];
    NSArray *appPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirPath = [appPaths objectAtIndex:0];
    NSString *magazineDirectory = [documentDirPath stringByAppendingPathComponent:latestMagazineID];
    if ([df fileExistsAtPath:magazineDirectory]) {
        // загрузка картинки из файловой системы
        NSString *coverPath = [magazineDirectory stringByAppendingPathComponent:@"cover.jpg"];
        NSData *imageData = [NSData dataWithContentsOfFile:coverPath];
        UIImage *coverImage = [UIImage imageWithData:imageData];
        [self.magazineImageView setImage:coverImage forState:UIControlStateNormal];
    } else {
        // асинхронная загрузка картинки из веба
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:cover]];
            UIImage *coverImage = [UIImage imageWithData:imageData];
            [self.magazineImageView setImage:coverImage forState:UIControlStateNormal];
        }];
    }
    
    // раздисейбливаем кнопочки
    self.magazineImageView.enabled = YES;
    self.loadMagazineButton.enabled = YES;
    
    [connection release];
    [latestMagazineData release];
}


@end
