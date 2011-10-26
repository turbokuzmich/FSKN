//
//  DrugMapViewController.h
//  FSKN 2
//
//  Created by Дмитрий on 28.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrugMapViewController : UIViewController {
    BOOL animationDone;
    BOOL cityShown;
    CGRect piterRect;
    CGRect novosibRect;
    CGRect saratovRect;
}

@property (nonatomic, retain) IBOutlet UIImageView *redMap;

@property (nonatomic, retain) IBOutlet UIImageView *arrows1;
@property (nonatomic, retain) IBOutlet UIImageView *arrows2;
@property (nonatomic, retain) IBOutlet UIImageView *arrows3;
@property (nonatomic, retain) IBOutlet UIImageView *arrows4;

@property (nonatomic, retain) IBOutlet UIButton *piter;
@property (nonatomic, retain) IBOutlet UIButton *novosib;
@property (nonatomic, retain) IBOutlet UIButton *saratov;

@property (nonatomic, retain) IBOutlet UIImageView *pins;

@property (nonatomic, retain) UIBarButtonItem *replayButton;


- (void)startArrows1Animation;
- (void)startArrows2Animation;
- (void)startArrows3Animation;
- (void)startArrows4Animation;

- (void)startPinsAnimation;

- (void)animationsDone;

- (IBAction)cityBubblePressed:(id)sender;

- (IBAction)backButtonPressed;

- (IBAction)replayButtonPressed:(id)sender;


@end
