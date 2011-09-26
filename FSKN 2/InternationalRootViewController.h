//
//  RootViewController.h
//  FSKN 2
//
//  Created by Дмитрий on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InternationalDetailViewController;

@interface InternationalRootViewController : UITableViewController {
    
}

@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) IBOutlet InternationalDetailViewController *detailViewController;

@end
