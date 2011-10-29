//
//  PublicationController.h
//  FSKN 2
//
//  Created by Дмитрий Куртеев on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineWindow.h"

@interface PublicationController : UIViewController<TapDetectionWindowDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSString *num;
@property (nonatomic, retain) NSMutableArray *webViewsToObserve;
@property (nonatomic, retain) IBOutlet UIButton* leftButton;
@property (nonatomic, retain) IBOutlet UIButton* rightButton;

- (IBAction)left:(id)sender;
- (IBAction)right:(id)sender;

@end
