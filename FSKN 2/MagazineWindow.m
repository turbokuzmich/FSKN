//
//  MagazineWindow.m
//  FSKN 2
//
//  Created by Дмитрий Куртеев on 29.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MagazineWindow.h"
#import "PublicationController.h"

@implementation MagazineWindow

- (void)sendEvent:(UIEvent *)event;
{
    [super sendEvent:event];
    
    UINavigationController *navigationController = (UINavigationController *)self.rootViewController;
    UIViewController *topController = [navigationController topViewController];
    
    if (![topController isKindOfClass:[PublicationController class]]) return;
    
    PublicationController *controller = (PublicationController *)[navigationController topViewController];
    NSArray *webViews = [controller webViewsToObserve];
    
    if ([webViews count] == 0) return;
    
    NSSet *touches = [event allTouches];
    
    if ([touches count] != 1) return;
    
    UITouch *touch = touches.anyObject;
    
    if ([touch phase] != UITouchPhaseEnded) return;
    
    BOOL isDescendantOfWebViews = NO;
    for (UIWebView *w in webViews) {
        if ([touch.view isDescendantOfView:w]) {
            isDescendantOfWebViews = YES;
        }
    }
    if (!isDescendantOfWebViews) return;
    
    if (touch.tapCount == 1) {
        [controller performSelector:@selector(userDidTapWebView)];
    }
    else if (touch.tapCount > 1) {
        [NSObject cancelPreviousPerformRequestsWithTarget:controller selector:@selector(userDidTapWebView) object:nil];
    }}

@end
