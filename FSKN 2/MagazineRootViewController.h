//
//  MagazineRootViewController.h
//  FSKN 2
//
//  Created by Дмитрий Куртеев on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
Reachability *internetReachable;

@interface MagazineRootViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>

@property (nonatomic, retain) NSMutableArray *localPublications;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *wantPublicationsButton;
@property (nonatomic, retain) NSOperationQueue *imageLoadOperationQueue;
@property (nonatomic, retain) NSString *publicationToShow;

- (void)showPublicationWithID:(NSString *)ID;

- (void)updateLocalPublications;

- (BOOL)checkNetworkStatus;

- (void)loadPublicationsXml;

- (void)showStatusWithMessage:(NSString *)message;

- (IBAction)wantsPublications:(id)sender;
- (void)disableWantPublicationsButton;
- (void)restoreWantPublicationsButton;

- (void)loadImageForCellAtIndex:(NSIndexPath *)indexPath withPath:(NSString *)path;
- (void)loadButtonPressed:(id)sender;
- (void)loadPublicationForCellAtPath:(NSIndexPath *)path;
- (void)loadPublicationWithID:(NSString *)ID;

- (BOOL)publicationsAreDownloading;

@end
