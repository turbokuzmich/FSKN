//
//  StatisticsPageControl.h
//  FSKN 2
//
//  Created by Дмитрий on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COBIPAGECONTROL_HEIGHT 20
#define DOT_WIDTH 6
#define DOT_SPACING 10

@interface StatisicsPageControl : UIView {
    int numberOfPages;
    int currentPage;
    UIColor* selectedColor;
    UIColor* deselectedColor;
}

@property (assign) int numberOfPages;
@property (assign) int currentPage;
@property (nonatomic, retain) UIColor* selectedColor;
@property (nonatomic, retain) UIColor* deselectedColor;

@end