//
//  MagazineRootViewController.h
//  FSKN 2
//
//  Created by Дмитрий Куртеев on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagazineRootViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *localPublications;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIFont *urlFont;

- (void)updateLocalPublications;

@end
