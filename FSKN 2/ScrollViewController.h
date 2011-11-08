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
    IBOutlet UIView *statistics4;
    IBOutlet UIView *statistics5;
    IBOutlet UIView *statistics6;
    IBOutlet UIView *statistics7;
    IBOutlet UIView *statistics8;
    IBOutlet UIView *statistics9;
    IBOutlet UIView *statistics10;
    IBOutlet UIView *statistics11;
    IBOutlet UIView *statistics12;
    IBOutlet UIView *statistics13;
    IBOutlet UIView *statistics14;
    IBOutlet UIView *statistics15;
    IBOutlet UIView *statistics16;
    IBOutlet UIPageControl *pageControl;
    BOOL pagingIsEnabled;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *statistics1;
@property (nonatomic, retain) UIView *statistics2;
@property (nonatomic, retain) UIView *statistics3;
@property (nonatomic, retain) UIView *statistics4;
@property (nonatomic, retain) UIView *statistics5;
@property (nonatomic, retain) UIView *statistics6;
@property (nonatomic, retain) UIView *statistics7;
@property (nonatomic, retain) UIView *statistics8;
@property (nonatomic, retain) UIView *statistics9;
@property (nonatomic, retain) UIView *statistics10;
@property (nonatomic, retain) UIView *statistics11;
@property (nonatomic, retain) UIView *statistics12;
@property (nonatomic, retain) UIView *statistics13;
@property (nonatomic, retain) UIView *statistics14;
@property (nonatomic, retain) UIView *statistics15;
@property (nonatomic, retain) UIView *statistics16;
@property (nonatomic, retain) UIPageControl *pageControl;

@end
