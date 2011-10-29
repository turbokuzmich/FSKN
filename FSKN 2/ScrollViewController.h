//
//  ScrollViewController.h
//  FSKN
//
//  Created by Дмитрий on 17.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScrollViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *statistics1;
    IBOutlet UIView *statistics2;
    IBOutlet UIView *statistics3;
    IBOutlet UIPageControl *pageControl;
    BOOL pagingIsEnabled;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *statistics1;
@property (nonatomic, retain) UIView *statistics2;
@property (nonatomic, retain) UIView *statistics3;
@property (nonatomic, retain) UIPageControl *pageControl;

@end
