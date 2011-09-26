//
//  ThesisViewController.h
//  FSKN 2
//
//  Created by Дмитрий on 28.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThesisViewController : UIViewController <UIWebViewDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (IBAction)backButtonPressed;

@end
