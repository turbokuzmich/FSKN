//
//  MagazineWindow.h
//  FSKN 2
//
//  Created by Дмитрий Куртеев on 29.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapDetectionWindowDelegate
- (void)userDidTapWebView;
@end

@interface MagazineWindow : UIWindow

@end
