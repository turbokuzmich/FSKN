//
//  FSKN_2AppDelegate.h
//  FSKN 2
//
//  Created by Дмитрий on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@class DetailViewController;

@class StartScreenViewController;

@class ScrollViewController;

@class MainScreenViewController;

@class GeographyViewController;

@class ThesisViewController;

@class StructureViewController;

@class BiographyViewController;

@class DrugMapViewController;

@class MagazineRootViewController;

@interface FSKN_2AppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) IBOutlet UIWindow *startScreenWindow;

@property (nonatomic, retain) IBOutlet StartScreenViewController *startScreenViewController;

@property (nonatomic, retain) IBOutlet UIWindow *statisticsWindow;

@property (nonatomic, retain) IBOutlet ScrollViewController *statisticsViewController;

@property (nonatomic, retain) IBOutlet UIWindow *mainScreenWindow;

@property (nonatomic, retain) IBOutlet MainScreenViewController *mainScreenViewController;

@property (nonatomic, retain) IBOutlet UIWindow *georgaphyWindow;

@property (nonatomic, retain) IBOutlet GeographyViewController *geographyViewController;

@property (nonatomic, retain) IBOutlet UIWindow *internationalWindow;

@property (nonatomic, retain) IBOutlet UISplitViewController *internationalSplitViewController;

@property (nonatomic, retain) IBOutlet UIWindow *thesisWindow;

@property (nonatomic, retain) IBOutlet ThesisViewController *thesisController;

@property (nonatomic, retain) IBOutlet UIWindow *structureWindow;

@property (nonatomic, retain) IBOutlet StructureViewController *structureController;

@property (nonatomic, retain) IBOutlet UIWindow *biographyWindow;

@property (nonatomic, retain) IBOutlet BiographyViewController *biographyController;

@property (nonatomic, retain) IBOutlet UIWindow *drugMapWindow;

@property (nonatomic, retain) IBOutlet DrugMapViewController *drugMapController;

@property (nonatomic, retain) IBOutlet UIWindow *magazineWindow;

@property (nonatomic, retain) IBOutlet UINavigationController *magazineNavigationController;

@property (nonatomic, retain) IBOutlet MagazineRootViewController *magazineRootViewController;

@property (nonatomic, retain) IBOutlet UIButton *magazineImageView;

@property (nonatomic, retain) IBOutlet UIButton *loadMagazineButton;


- (IBAction)goToYoutube;
- (IBAction)goToMain;
- (IBAction)goToGeography;
- (IBAction)goToStatistics;
- (IBAction)goToDocuments;
- (IBAction)goToInternational;
- (IBAction)goToThesis;
- (IBAction)goToStructure;
- (IBAction)goToBlog;
- (IBAction)goToStrategy;
- (IBAction)goToBiography;
- (IBAction)goToDrugMap;
- (IBAction)goToMagazine;

- (IBAction)loadLatestMagazine;


@end
