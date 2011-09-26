//
//  StructureViewController.h
//  FSKN 2
//
//  Created by Дмитрий on 28.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StructureViewController : UIViewController <UIWebViewDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (IBAction)backButtonPressed;

@end
