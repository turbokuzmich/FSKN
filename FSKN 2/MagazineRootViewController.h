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
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIFont *urlFont;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *wantPublicationsButton;

- (void)updateLocalPublications;

- (BOOL)checkNetworkStatus;

- (void)loadPublicationsXml;
- (void)checkLocalPublicationsList;
- (void)downloadMissingPublications;

- (void)showStatusWithMessage:(NSString *)message;

- (IBAction)wantsPublications:(id)sender;
- (void)disableWantPublicationsButton;
- (void)restoreWantPublicationsButton;

@end
