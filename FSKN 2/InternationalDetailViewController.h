//
//  DetailViewController.h
//  FSKN 2
//
//  Created by Дмитрий on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternationalDetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIWebViewDelegate> {
    
}

- (IBAction)backButtonClicked;

@property (nonatomic, retain) IBOutlet UINavigationBar *navi;

@property (nonatomic, retain) NSArray *listOfFiles;

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;

@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@end

